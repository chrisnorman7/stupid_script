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
    this.argumentSeparator = '|',
    this.variableBracket = '%',
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

  /// The argument separator to use.
  final String argumentSeparator;

  /// The characters to surround variable names for expansion.
  final String variableBracket;

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
  Future<void> handleLine(final String line) async {
    if (line.startsWith(comment)) {
      return;
    }
    final index = line.indexOf(' ');
    final String commandName;
    final String argumentsString;
    if (index == -1) {
      commandName = line;
      argumentsString = '';
    } else {
      commandName = line.substring(0, index);
      argumentsString = line.substring(index + 1);
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
  Future<void> callCommand(
    final ScriptCommand command,
    final List<String> arguments,
  ) async {
    if (arguments.length != command.arguments.length) {
      throw ArgumentMismatch(command: command, actualNumber: arguments.length);
    }
    final argumentsMap = <String, String>{};
    for (var i = 0; i < command.arguments.length; i++) {
      final argument = command.arguments[i];
      argumentsMap[argument.name] = substituteText(arguments[i]);
    }
    await command.invoke(this, argumentsMap);
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
