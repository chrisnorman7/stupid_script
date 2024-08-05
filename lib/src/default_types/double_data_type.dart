import '../data_type.dart';
import '../exceptions.dart';

/// A data type which represents a [double].
class DoubleDataType extends DataType<double> {
  /// Create an instance.
  const DoubleDataType()
      : super(
          name: 'double',
        );

  /// Convert from a raw value.
  @override
  double fromRawValue(final String value) {
    final d = double.tryParse(value);
    if (d == null) {
      throw ConversionError(value: value, type: this);
    }
    return d;
  }

  /// Convert to a raw value.
  @override
  String toRawValue(final double value) => value.toString();
}
