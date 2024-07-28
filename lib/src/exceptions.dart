import '../stupid_script.dart';

/// The top-level exception.
class StupidScriptException implements Exception {
  /// Create an instance.
  const StupidScriptException({required this.message});

  /// The message to use.
  final String message;

  /// Pretty print.
  @override
  String toString() => message;
}

/// There was an error with a command argument.
class ScriptCommandArgumentError extends StupidScriptException {
  /// Create an instance.
  ScriptCommandArgumentError({
    required this.command,
    required this.argument,
    required this.value,
    this.problem = 'Invalid value',
  }) : super(
          message:
              'In command ${command.name}, $problem: argument ${argument.name}'
              ' = '
              '$value',
        );

  /// The command which caused the error.
  final ScriptCommand command;

  /// The argument which caused the error.
  final ScriptCommandArgument argument;

  /// The value which caused the error.
  final String value;

  /// The problem with [value].
  final String problem;
}

/// No command was found.
class CommandNotFound extends StupidScriptException {
  /// Create an instance.
  const CommandNotFound(final String name)
      : super(message: 'Command not found: $name.');
}

/// An invalid number of arguments was passed.
class ArgumentMismatch extends StupidScriptException {
  /// Create an instance.
  ArgumentMismatch({
    required final ScriptCommand command,
    required final int actualNumber,
  }) : super(
          message: 'Invalid number of arguments for ${command.name}. Expected '
              '${command.optionalArguments.isEmpty ? "exactly "
                  "${minSupportedArguments(command)}" : "between "
                  "${minSupportedArguments(command)} and "
                  "${maxSupportedArguments(command)}"}, '
              'got $actualNumber.',
        );

  /// Return the minimum number of arguments supported by [command].
  static int minSupportedArguments(final ScriptCommand command) =>
      command.arguments.length;

  /// Return the maximum number of arguments supported by [command].
  static int maxSupportedArguments(final ScriptCommand command) =>
      minSupportedArguments(command) + command.optionalArguments.length;
}

/// A general script error occurred.
class ScriptError extends StupidScriptException {
  /// Create an instance.
  const ScriptError({
    required this.lineNumber,
    required this.exception,
    required this.stackTrace,
    super.message = 'Script error',
  });

  /// The line number of the script where the error occurred.
  final int lineNumber;

  /// The exception which occurred.
  final Exception exception;

  /// The stack trace to use.
  final StackTrace stackTrace;
}
