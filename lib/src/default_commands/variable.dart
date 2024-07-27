import 'dart:async';

import '../commands/script_command.dart';
import '../commands/script_command_argument.dart';
import '../script_context.dart';

/// The var command.
class Variable implements ScriptCommand<void> {
  /// Create an instance.
  const Variable();

  /// The name argument.
  static const nameArgument = ScriptCommandArgument(
    name: 'name',
    description: 'The name of the variable to create.',
  );

  /// The value argument.
  static const valueArgument = ScriptCommandArgument(
    name: 'value',
    description: 'The value to store.',
  );

  /// The name of this command.
  @override
  String get name => 'var';

  /// The example.
  @override
  List<String> get example => [
        '# Store a variable:',
        'var a|1234',
        'var text|Hello world. This is a string.',
      ];

  /// The arguments to use.
  @override
  List<ScriptCommandArgument> get arguments => [
        nameArgument,
        valueArgument,
      ];

  /// Invoke the command.
  @override
  FutureOr<void> invoke(
    final ScriptContext scriptContext,
    final Map<String, String> arguments,
  ) {
    final name = arguments[nameArgument.name]!;
    final value = arguments[valueArgument.name]!;
    scriptContext.variables[name] = value;
  }
}
