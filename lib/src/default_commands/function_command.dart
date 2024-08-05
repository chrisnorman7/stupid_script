import 'dart:async';

import '../commands/arguments/script_command_argument.dart';
import '../commands/arguments/script_command_optional_argument.dart';
import '../commands/script_command.dart';
import '../data_type.dart';
import '../default_types/string_data_type.dart';
import '../exceptions.dart';
import '../script_context.dart';
import '../script_function.dart';

/// The function command.
class FunctionCommand extends ScriptCommand<String> {
  /// Create an instance.
  const FunctionCommand();

  /// The name argument.
  static const ScriptCommandArgument nameArgument = ScriptCommandArgument(
    name: 'name',
    description: 'The name of the new function.',
    type: StringDataType(),
  );

  /// The arguments argument.
  static const ScriptCommandOptionalArgument argumentsArgument =
      ScriptCommandOptionalArgument(
    name: 'arguments',
    description: 'The arguments to add to this function.',
    type: StringDataType(),
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
        .split('|')
        .map((final string) {
      final values = string.split(':');
      final argumentName = values.first;
      final String description;
      final DataType argumentType;
      if (values.length == 1) {
        description = 'The $argumentName argument.';
        argumentType = const StringDataType();
      } else if (values.length == 2) {
        description = values.last;
        argumentType = const StringDataType();
      } else if (values.length == 3) {
        description = values[1];
        final typeName = values.last;
        try {
          argumentType = scriptContext.runner.types
              .firstWhere((final type) => type.name == typeName);
          // ignore: avoid_catching_errors
        } on StateError {
          throw InvalidArgumentTypeName(typeName: typeName);
        }
      } else {
        throw InvalidArgumentDefinition(
          runner: scriptContext.runner,
          argumentDefinition: string,
        );
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
