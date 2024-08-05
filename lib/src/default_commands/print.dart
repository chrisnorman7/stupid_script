// ignore_for_file: avoid_print
import '../commands/arguments/script_command_argument.dart';
import '../commands/arguments/script_command_optional_argument.dart';
import '../commands/script_command.dart';
import '../default_types/string_data_type.dart';
import '../script_context.dart';

/// The print command.
class Print extends ScriptCommand<void> {
  /// Create an instance.
  const Print();

  /// The text argument.
  static const textArgument = ScriptCommandArgument(
    name: 'text',
    description: 'The text to print.',
    type: StringDataType(),
  );

  /// The arguments.
  @override
  List<ScriptCommandArgument> get arguments => [textArgument];

  /// Optional arguments.
  @override
  List<ScriptCommandOptionalArgument> get optionalArguments => [];

  /// A suitable example.
  @override
  List<String> get example => [
        '# Print some text.',
        'print Hello world.',
      ];

  /// Run this command.
  @override
  void invoke(
    final ScriptContext scriptContext,
    final Map<String, dynamic> arguments,
  ) {
    final text = arguments[textArgument.name];
    print(text);
  }

  /// The name of this command.
  @override
  String get name => 'print';
}
