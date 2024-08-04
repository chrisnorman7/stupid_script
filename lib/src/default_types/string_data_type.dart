import '../data_type.dart';

String _fromValue(final String value) => value;
String _toValue(final String value) => value;

/// A data type which represents a [String].
class StringDataType extends DataType<String> {
  /// Create an instance.
  const StringDataType()
      : super(
          name: 'string',
          fromRawValue: _fromValue,
          toRawValue: _toValue,
        );
}
