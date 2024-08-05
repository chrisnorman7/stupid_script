import 'commands/arguments/script_command_argument.dart';
import 'commands/script_command.dart';
import 'data_type.dart';
import 'script_runner.dart';

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

/// The given [value] could not be converted to the specified [type].
class ConversionError extends StupidScriptException {
  /// Create an instance.
  ConversionError({
    required this.value,
    required this.type,
  }) : super(message: 'Could not convert "$value" to type ${type.name}.');

  /// The original value.
  final String value;

  /// The type which [value] was supposed to convert to.
  final DataType type;
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

/// The function end command was found in the wrong place.
class NoCurrentFunction extends StupidScriptException {
  /// Make it constant.
  NoCurrentFunction(
    final String functionEnd,
  ) : super(message: 'Unexpected `$functionEnd`.');
}

/// An invalid name was given for an argument type.
class InvalidArgumentTypeName extends StupidScriptException {
  /// Create an instance.
  InvalidArgumentTypeName({
    required this.typeName,
  }) : super(message: 'Invalid type name: $typeName.');

  /// The name of the supposed type which was given.
  final String typeName;
}

/// An invalid argument definition was given.
class InvalidArgumentDefinition extends StupidScriptException {
  /// Create an instance.
  InvalidArgumentDefinition({
    required final ScriptRunner runner,
    required this.argumentDefinition,
  }) : super(
          message: 'Invalid argument type definition: $argumentDefinition. '
              'Expected <name>:<type>, where type is one of '
              '${runner.types}.',
        );

  /// The definition which was given.
  final String argumentDefinition;
}

/// Could not determine the type of [value].
class UnknownType extends StupidScriptException {
  /// Create an instance.
  UnknownType(this.value)
      : super(message: 'Could not determine the type of `$value`.');

  /// The value which could not be converted.
  final dynamic value;
}
