import '../commands/arguments/script_command_argument.dart';
import '../commands/arguments/script_command_optional_argument.dart';
import '../commands/script_command.dart';
import '../script_context.dart';

/// The variables command.
class Variables extends ScriptCommand<String> {
  /// Create an instance.
  const Variables();

  /// There are no arguments.
  @override
  List<ScriptCommandArgument> get arguments => [];

  /// Usage examples.
  @override
  List<String> get example => [
        'variables # Returns a comma-separated list of variable names.',
      ];

  /// Invoke the command.
  @override
  String invoke(
    final ScriptContext scriptContext,
    final Map<String, dynamic> arguments,
  ) =>
      scriptContext.variables.keys.join(',');

  /// The name of this command.
  @override
  String get name => 'variables';

  /// There are no arguments.
  @override
  List<ScriptCommandOptionalArgument> get optionalArguments => [];
}
