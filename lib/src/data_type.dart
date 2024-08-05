import '../src/script_runner.dart';

/// A type which can be supported by a [ScriptRunner].
abstract class DataType<T> {
  /// Create an instance.
  const DataType({
    required this.name,
  });

  /// The name of this type.
  final String name;

  /// The function which converts raw values to the correct type.
  T fromRawValue(final String value);

  /// The function which will convert instances of this type to a raw value.
  String toRawValue(final T value);

  /// Returns `true` if [value] is of type [T}.
  bool valueMatches(final dynamic value) => value is T;
}
