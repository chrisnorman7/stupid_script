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
  const ScriptCommandArgumentError({
    required this.command,
    required this.argument,
    required this.value,
    required super.message,
  });

  /// The command which caused the error.
  final ScriptCommand command;

  /// The argument which caused the error.
  final ScriptCommandArgument argument;

  /// The value which caused the error.
  final String value;

  /// Show a suitable message.
  @override
  String toString() =>
      '${command.name}: Argument ${argument.name} was given $value. $message';
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
              '${command.arguments.length}, got $actualNumber.',
        );
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
