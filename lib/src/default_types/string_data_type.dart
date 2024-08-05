import '../data_type.dart';

/// A data type which represents a [String].
class StringDataType extends DataType<String> {
  /// Create an instance.
  const StringDataType()
      : super(
          name: 'string',
        );

  /// Convert from a raw value.
  @override
  String fromRawValue(final String value) => value;

  /// Convert to a raw value.
  @override
  String toRawValue(final String value) => value;
}
