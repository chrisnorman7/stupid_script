import '../../data_type.dart';
import '../script_command.dart';

/// An argument for a [ScriptCommand].
class ScriptCommandArgument {
  /// Create an instance.
  const ScriptCommandArgument({
    required this.name,
    required this.description,
    required this.type,
  });

  /// The name of this argument.
  final String name;

  /// The description for this argument.
  final String description;

  /// The type of this argument.
  final DataType type;
}
