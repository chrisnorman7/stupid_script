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
  Future<void> handleLines(final List<String> script) async {
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
    final commandEnd = code.indexOf(runner.commandSeparator);
    final String commandName;
    final String argumentsString;
    if (commandEnd == -1) {
      commandName = line;
      argumentsString = '';
    } else {
      commandName = code.substring(0, commandEnd);
      argumentsString = code.substring(commandEnd + 1);
    }
    var arguments = argumentsString.split(runner.argumentSeparator);
    if (arguments.length == 1 && arguments.single.isEmpty) {
      arguments = [];
    }
    final command = runner.commandsMap[commandName];
    if (command == null) {
      throw CommandNotFound(commandName);
    }
    final value = await callCommand(command, arguments);
    variables['_'] = ScriptVariable(
      name: '_',
      type: runner.getValueType(value),
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
    return type.fromRawValue(fullValue);
  }

  /// Returns suitable arguments for [command].
  Map<String, dynamic> parseArguments(
    final ScriptCommand command,
    final List<String> arguments,
  ) {
    final minArguments = command.arguments.length;
    final maxArguments = minArguments + command.optionalArguments.length;
    if (arguments.length < minArguments || arguments.length > maxArguments) {
      throw ArgumentMismatch(command: command, actualNumber: arguments.length);
    }
    final argumentsMap = <String, dynamic>{};
    for (var i = 0; i < minArguments; i++) {
      final argument = command.arguments[i];
      final value = arguments[i];
      argumentsMap[argument.name] = parseArgument(argument, value);
    }
    for (var i = minArguments; i < maxArguments; i++) {
      final argument = command.optionalArguments[i - command.arguments.length];
      dynamic value;
      try {
        value = parseArgument(argument, arguments[i]);
        // ignore: avoid_catching_errors
      } on RangeError {
        value = parseArgument(
          argument,
          argument.defaultValue,
        );
      } finally {
        argumentsMap[argument.name] = value;
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
      '(?<!\\\\)${runner.variableBracket}($variableNames)',
    );
    return text.replaceAllMapped(
      regExp,
      (final match) {
        final variableName = match.group(match.groupCount)!;
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
