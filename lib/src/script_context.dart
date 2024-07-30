import 'dart:async';
import 'dart:math';

import 'commands/script_command.dart';
import 'exceptions.dart';
import 'script_runner.dart';

/// A context for a running script.
class ScriptContext {
  /// Create an instance.
  ScriptContext({
    required this.runner,
    required this.random,
    required this.variables,
    this.outputText = print,
    this.comment = '#',
    this.commandSeparator = ' ',
    this.argumentSeparator = '|',
    this.variableBracket = '%',
    this.blockStart = '{',
    this.blockEnd = '}',
  });

  /// The script runner to use.
  final ScriptRunner runner;

  /// The function to call to output text.
  ///
  /// The [outputText] function will default to [print], but should probably be
  /// changed to use the [logging](https://pub.dev/packages/logging) package.
  final FutureOr<void> Function(String) outputText;

  /// The random number generator to use.
  final Random random;

  /// The variables which have been created.
  final Map<String, String> variables;

  /// The character(s) which signify the start of a comment..
  final String comment;

  /// The character which separates a command from its arguments.
  final String commandSeparator;

  /// The argument separator to use.
  final String argumentSeparator;

  /// The characters to surround variable names for expansion.
  final String variableBracket;

  /// The character which starts an embedded script block.
  final String blockStart;

  /// The character which ends an embedded script block.
  final String blockEnd;

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
  Future<String?> handleLine(final String line) async {
    final code = line.split(comment).first.trim();
    if (code.isEmpty) {
      return null;
    }
    final blockEndIndex = code.lastIndexOf(blockEnd);
    if (blockEndIndex != -1) {
      final blockStartIndex = code.indexOf(blockStart);
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
    final index = code.indexOf(commandSeparator);
    final String commandName;
    final String argumentsString;
    if (index == -1) {
      commandName = line;
      argumentsString = '';
    } else {
      commandName = code.substring(0, index);
      argumentsString = code.substring(index + 1);
    }
    final arguments = argumentsString.split(argumentSeparator);
    for (final command in runner.commands) {
      if (command.name == commandName) {
        return callCommand(command, arguments);
      }
    }
    throw CommandNotFound(commandName);
  }

  /// Call [command] with [arguments].
  Future<String?> callCommand(
    final ScriptCommand command,
    final List<String> arguments,
  ) async {
    if (arguments.length < command.arguments.length) {
      throw ArgumentMismatch(command: command, actualNumber: arguments.length);
    } else if (arguments.length >
        (command.arguments.length + command.optionalArguments.length)) {
      throw ArgumentMismatch(command: command, actualNumber: arguments.length);
    }
    final argumentsMap = <String, String>{};
    for (var i = 0; i < command.arguments.length; i++) {
      final argument = command.arguments[i];
      argumentsMap[argument.name] = substituteText(arguments[i]);
    }
    for (var i = command.arguments.length;
        i < command.optionalArguments.length + command.arguments.length;
        i++) {
      final argument = command.optionalArguments[i - command.arguments.length];
      try {
        argumentsMap[argument.name] = substituteText(arguments[i]);
        // ignore: avoid_catching_errors
      } on RangeError {
        argumentsMap[argument.name] = argument.defaultValue;
      }
    }
    return command.invoke(this, argumentsMap);
  }

  /// Substitute [text] with data from [variables].
  String substituteText(final String text) {
    if (variables.isEmpty) {
      return text;
    }
    final variableNames = variables.keys.join('|');
    final regExp = RegExp(
      '([$variableBracket]($variableNames)[$variableBracket])',
    );
    return text.replaceAllMapped(
      regExp,
      (final match) {
        final variableName = match.group(2)!;
        final variableValue = variables[variableName];
        return variableValue ?? '<undefined>';
      },
    );
  }
}
