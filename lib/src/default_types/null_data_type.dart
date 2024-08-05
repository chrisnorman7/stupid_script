import '../data_type.dart';
import '../exceptions.dart';

/// A data type which represents a [int].
class NullDataType extends DataType<void> {
  /// Create an instance.
  const NullDataType()
      : super(
          name: 'null',
        );

  /// Convert from a raw value.
  @override
  void fromRawValue(final String value) {
    if (value == 'null') {
      return;
    }
    throw ConversionError(value: value, type: this);
  }

  /// Convert to a raw value.
  @override
  String toRawValue(final void value) => 'null';
}
