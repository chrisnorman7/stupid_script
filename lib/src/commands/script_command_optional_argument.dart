import 'script_command_argument.dart';

/// An optional [ScriptCommandArgument].
class ScriptCommandOptionalArgument extends ScriptCommandArgument {
  /// Create an instance.
  const ScriptCommandOptionalArgument({
    required super.name,
    required super.description,
    required this.defaultValue,
  });

  /// The default value.
  final String defaultValue;
}
