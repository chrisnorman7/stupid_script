import '../commands/script_command.dart';
import '../commands/script_command_argument.dart';
import '../commands/script_command_optional_argument.dart';
import '../script_context.dart';

/// The print command.
class Print implements ScriptCommand {
  /// Create an instance.
  const Print();

  /// The text argument.
  static const textArgument =
      ScriptCommandArgument(name: 'text', description: 'The text to print.');

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
  String? invoke(
    final ScriptContext scriptContext,
    final Map<String, String> arguments,
  ) {
    final text = arguments[textArgument.name]!;
    scriptContext.outputText(text);
    return null;
  }

  /// The name of this command.
  @override
  String get name => 'print';
}
