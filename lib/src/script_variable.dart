import 'commands/script_command_argument_type.dart';

/// A variable in a script.
class ScriptVariable {
  /// Create an instance.
  ScriptVariable({
    required this.name,
    required this.type,
    required this.value,
  });

  /// Create an instance from [value].
  factory ScriptVariable.fromValue(final String name, final dynamic value) {
    if (value is String) {
      return ScriptVariable(
        name: name,
        type: ScriptCommandArgumentType.string,
        value: value,
      );
    }
    if (value is int) {
      return ScriptVariable(
        name: name,
        type: ScriptCommandArgumentType.integer,
        value: value,
      );
    }
    if (value is double) {
      return ScriptVariable(
        name: name,
        type: ScriptCommandArgumentType.float,
        value: value,
      );
    }
    throw UnimplementedError(
      'Cannot create a variable for a value with type ${value.runtimeType}.',
    );
  }

  /// An undefined variable.
  ScriptVariable.undefined()
      : name = 'undefined',
        type = ScriptCommandArgumentType.string,
        value = undefined;

  /// The name of this variable.
  final String name;

  /// The type of this variable.
  final ScriptCommandArgumentType type;

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
