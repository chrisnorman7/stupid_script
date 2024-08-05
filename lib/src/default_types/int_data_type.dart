import '../data_type.dart';
import '../exceptions.dart';

/// A data type which represents a [int].
class IntDataType extends DataType<int> {
  /// Create an instance.
  const IntDataType()
      : super(
          name: 'int',
        );

  /// Convert from a raw value.
  @override
  int fromRawValue(final String value) {
    final i = int.tryParse(value);
    if (i == null) {
      throw ConversionError(value: value, type: this);
    }
    return i;
  }

  /// Convert to a raw value.
  @override
  String toRawValue(final int value) => value.toString();
}
