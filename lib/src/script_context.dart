import 'dart:async';

import '../stupid_script.dart';

/// A context for a running script.
class ScriptContext {
  /// Create an instance.
  ScriptContext({
    required this.runner,
    required this.variables,
    required this.functions,
  });

  /// The script runner to use.
  final ScriptRunner runner;

  /// The variables which have been created.
  final Map<String, ScriptVariable> variables;

  /// The functions which have been defined by the programmer.
  final List<ScriptFunction> functions;

  /// The function which is currently being added to.
  ScriptFunction? scriptFunction;

  /// Run a script, line by line.
  Future<void> run(final List<String> script) async {
    for (var i = 0; i < script.length; i++) {
      final line = script[i];
      try {
        await handleLine(line);
      } on Exception catch (e, s) {
        throw ScriptError(
          lineNumber: i,
          exception: e,
          stackTrace: s,
        );
      }
    }
  }

  /// Handle a single [line].
  Future<dynamic> handleLine(final String line) async {
    final code = line.split(runner.comment).first.trim();
    if (code.isEmpty) {
      return null;
    }
    final function = scriptFunction;
    if (code == runner.functionEnd) {
      if (function == null) {
        throw NoCurrentFunction(runner.functionEnd);
      } else {
        functions.add(function);
        scriptFunction = null;
      }
      return null;
    }
    if (function != null) {
      function.lines.add(line);
      return null;
    }
    final blockEndIndex = code.lastIndexOf(runner.blockEnd);
    if (blockEndIndex != -1) {
      final blockStartIndex = code.indexOf(runner.blockStart);
      if (blockEndIndex != -1 && blockStartIndex < blockEndIndex) {
        final subLine = code.substring(blockStartIndex + 1, blockEndIndex);
        final result = await handleLine(subLine);
        final buffer = StringBuffer()
          ..write(code.substring(0, blockStartIndex))
          ..write(result)
          ..write(code.substring(blockEndIndex + 1));
        return handleLine(buffer.toString());
      }
    }
    final index = code.indexOf(runner.commandSeparator);
    final String commandName;
    final String argumentsString;
    if (index == -1) {
      commandName = line;
      argumentsString = '';
    } else {
      commandName = code.substring(0, index);
      argumentsString = code.substring(index + 1);
    }
    final arguments = argumentsString.split(runner.argumentSeparator);
    final command = runner.commandsMap[commandName];
    if (command == null) {
      throw CommandNotFound(commandName);
    }
    final value = await callCommand(command, arguments);
    variables['_'] = ScriptVariable(
      name: '_',
      type: ScriptCommandArgumentType.string,
      value: value,
    );
    return value;
  }

  /// Get all commands, including [functions].
  List<ScriptCommand> get getAllCommands => [
        ...runner.commands,
        ...functions.map(ScriptFunctionCommand.new),
      ];

  /// Parse a single [argument] from [value].
  dynamic parseArgument(
    final ScriptCommandArgument argument,
    final String value,
  ) {
    final fullValue = substituteText(value);
    final type = argument.type;
    switch (type) {
      case ScriptCommandArgumentType.string:
        return fullValue;
      case ScriptCommandArgumentType.integer:
        final i = int.tryParse(fullValue);
        if (i == null) {
          throw ConversionError(value: fullValue, type: type);
        }
        return i;
      case ScriptCommandArgumentType.float:
        final d = double.tryParse(fullValue);
        if (d == null) {
          throw ConversionError(value: fullValue, type: type);
        }
        return d;
    }
  }

  /// Returns suitable arguments for [command].
  Map<String, dynamic> parseArguments(
    final ScriptCommand command,
    final List<String> arguments,
  ) {
    if (arguments.length < command.arguments.length) {
      throw ArgumentMismatch(command: command, actualNumber: arguments.length);
    } else if (arguments.length >
        (command.arguments.length + command.optionalArguments.length)) {
      throw ArgumentMismatch(command: command, actualNumber: arguments.length);
    }
    final argumentsMap = <String, dynamic>{};
    for (var i = 0; i < command.arguments.length; i++) {
      final argument = command.arguments[i];
      final value = arguments[i];
      argumentsMap[argument.name] = parseArgument(argument, value);
    }
    for (var i = command.arguments.length;
        i < command.optionalArguments.length + command.arguments.length;
        i++) {
      final argument = command.optionalArguments[i - command.arguments.length];
      try {
        argumentsMap[argument.name] = parseArgument(argument, arguments[i]);
        // ignore: avoid_catching_errors
      } on RangeError {
        argumentsMap[argument.name] =
            parseArgument(argument, argument.defaultValue);
      }
    }
    return argumentsMap;
  }

  /// Call [command] with [arguments].
  Future<dynamic> callCommand(
    final ScriptCommand command,
    final List<String> arguments,
  ) async {
    final argumentsMap = parseArguments(command, arguments);
    return command.invoke(this, argumentsMap);
  }

  /// Substitute [text] with data from [variables].
  String substituteText(final String text) {
    if (variables.isEmpty) {
      return text;
    }
    final variableNames = variables.keys.join('|');
    final regExp = RegExp(
      '([^${runner.escapeChar}][${runner.variableBracket}]($variableNames))',
    );
    return text.replaceAllMapped(
      regExp,
      (final match) {
        final variableName = match.group(2)!;
        return getVariableValue(variableName);
      },
    );
  }

  /// Get the value of a [ScriptVariable] from [variables] with the given
  /// [name].
  dynamic getVariableValue(
    final String name, {
    final dynamic defaultValue = undefined,
  }) {
    final variable = variables[name];
    return variable?.value ?? defaultValue;
  }
}
