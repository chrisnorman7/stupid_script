import '../script_command.dart';
import 'script_command_argument_type.dart';

/// An argument for a [ScriptCommand].
class ScriptCommandArgument {
  /// Create an instance.
  const ScriptCommandArgument({
    required this.name,
    required this.description,
    this.type = ScriptCommandArgumentType.string,
  });

  /// The name of this argument.
  final String name;

  /// The description for this argument.
  final String description;

  /// The type of this argument.
  final ScriptCommandArgumentType type;
}
