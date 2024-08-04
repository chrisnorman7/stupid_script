import '../src/script_runner.dart';

/// A type which can be supported by a [ScriptRunner].
class DataType<T> {
  /// Create an instance.
  const DataType({
    required this.name,
    required this.fromRawValue,
    required this.toRawValue,
  });

  /// The name of this type.
  final String name;

  /// The function which converts raw values to the correct type.
  final T Function(String value) fromRawValue;

  /// The function which will convert instances of this type to a raw value.
  final String Function(T value) toRawValue;
}
