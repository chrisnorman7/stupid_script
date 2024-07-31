import '../../stupid_script.dart';
import '../commands/arguments/script_command_optional_argument.dart';

/// The var command.
class Variable extends ScriptCommand<String> {
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

  /// The type argument.
  static final typeArgument = ScriptCommandOptionalArgument(
    name: 'type',
    description: 'The type of this variable',
    defaultValue: ScriptCommandArgumentType.string.name,
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

  /// Optional arguments.
  @override
  List<ScriptCommandOptionalArgument> get optionalArguments => [typeArgument];

  /// Invoke the command.
  @override
  String? invoke(
    final ScriptContext scriptContext,
    final Map<String, dynamic> arguments,
  ) {
    final name = arguments[nameArgument.name];
    final value = arguments[valueArgument.name];
    scriptContext.variables[name] = value;
    return value;
  }
}
