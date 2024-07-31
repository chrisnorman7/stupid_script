import 'script_command_argument.dart';
import 'script_command_argument_type.dart';

/// An optional [ScriptCommandArgument].
class ScriptCommandOptionalArgument extends ScriptCommandArgument {
  /// Create an instance.
  const ScriptCommandOptionalArgument({
    required super.name,
    required super.description,
    required this.defaultValue,
    super.type = ScriptCommandArgumentType.string,
  });

  /// The default value.
  final String defaultValue;
}
