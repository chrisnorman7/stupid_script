import 'data_type.dart';
import 'default_types/string_data_type.dart';

/// A variable in a script.
class ScriptVariable {
  /// Create an instance.
  ScriptVariable({
    required this.name,
    required this.type,
    required this.value,
  });

  /// An undefined variable.
  ScriptVariable.undefined()
      : name = 'undefined',
        type = const StringDataType(),
        value = undefined;

  /// The name of this variable.
  final String name;

  /// The type of this variable.
  final DataType type;

  /// The value of this variable.
  dynamic value;
}

/// The undefined variable value.
class _Undefined {
  /// Create an instance.
  const _Undefined();
}

/// The undefined value.
const undefined = _Undefined();
