import 'dart:async';

import '../commands/script_command.dart';
import '../commands/script_command_argument.dart';
import '../script_context.dart';

/// The print command.
class Print implements ScriptCommand<void> {
  /// Create an instance.
  const Print();

  /// The text argument.
  static const textArgument =
      ScriptCommandArgument(name: 'text', description: 'The text to print.');

  /// The arguments.
  @override
  List<ScriptCommandArgument> get arguments => [textArgument];

  /// A suitable example.
  @override
  List<String> get example => [
        '# Print some text.',
        'print Hello world.',
      ];

  /// Run this command.
  @override
  FutureOr<void> invoke(
    final ScriptContext scriptContext,
    final Map<String, String> arguments,
  ) {
    final text = arguments[textArgument.name]!;
    return scriptContext.outputText(text);
  }

  /// The name of this command.
  @override
  String get name => 'print';
}
