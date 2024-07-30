import 'commands/script_command_argument.dart';

/// A function in a script.
///
/// Script functions are created by stupid programmers to make their stupid
/// scripts less stupid.
class ScriptFunction {
  /// Create an instance.
  const ScriptFunction({
    required this.name,
    required this.arguments,
    required this.lines,
  });

  /// The name of this function.
  final String name;

  /// The arguments of this function.
  final List<ScriptCommandArgument> arguments;

  /// The lines of code for this function.
  final List<String> lines;
}
