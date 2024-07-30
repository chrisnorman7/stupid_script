import 'dart:async';

import '../commands/script_command.dart';
import '../commands/script_command_argument.dart';
import '../commands/script_command_argument_type.dart';
import '../commands/script_command_optional_argument.dart';
import '../exceptions.dart';
import '../script_context.dart';
import '../script_function.dart';

/// The function command.
class FunctionCommand implements ScriptCommand {
  /// Create an instance.
  const FunctionCommand();

  /// The name argument.
  static const ScriptCommandArgument nameArgument = ScriptCommandArgument(
    name: 'name',
    description: 'The name of the new function.',
  );

  /// The arguments argument.
  static const ScriptCommandOptionalArgument argumentsArgument =
      ScriptCommandOptionalArgument(
    name: 'arguments',
    description: 'The arguments to add to this function.',
    defaultValue: '',
  );

  /// The arguments for this command.
  @override
  List<ScriptCommandArgument> get arguments => [nameArgument];

  /// Example usage.
  @override
  List<String> get example => [
        'function print_line|line_number:integer,text:string',
        '  print [%line_number%]: %text%',
        'end',
      ];

  /// Run this command.
  @override
  FutureOr<String?> invoke(
    final ScriptContext scriptContext,
    final Map<String, dynamic> arguments,
  ) {
    final name = arguments[nameArgument.name] as String;
    final functionArguments = (arguments[argumentsArgument.name] as String)
        .split(',')
        .map((final string) {
      final values = string.split(':');
      final argumentName = values.first;
      final String description;
      final ScriptCommandArgumentType argumentType;
      if (values.length == 1) {
        description = 'The $argumentName argument.';
        argumentType = ScriptCommandArgumentType.string;
      } else if (values.length == 2) {
        description = values.last;
        argumentType = ScriptCommandArgumentType.string;
      } else if (values.length == 3) {
        description = values[1];
        final typeName = values.last;
        try {
          argumentType = ScriptCommandArgumentType.values
              .firstWhere((final type) => type.name == typeName);
          // ignore: avoid_catching_errors
        } on StateError {
          throw InvalidArgumentType(typeName: typeName);
        }
      } else {
        throw InvalidArgumentDefinition(argumentDefinition: string);
      }
      return ScriptCommandArgument(
        name: argumentName,
        description: description,
        type: argumentType,
      );
    }).toList();
    scriptContext.scriptFunction = ScriptFunction(
      name: name,
      arguments: functionArguments,
      lines: [],
    );
    return name;
  }

  /// The name of this command.
  @override
  String get name => 'function';

  /// Return optional arguments.
  @override
  List<ScriptCommandOptionalArgument> get optionalArguments =>
      [argumentsArgument];
}
