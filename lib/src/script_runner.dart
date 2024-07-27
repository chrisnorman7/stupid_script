import '../default_commands.dart';
import 'commands/script_command.dart';

/// A class for running scripts.
class ScriptRunner {
  /// Create an instance.
  const ScriptRunner({
    required this.commands,
  });

  /// Create a default instance.
  const ScriptRunner.withDefaults() : commands = defaultCommands;

  /// The commands to use.
  final List<ScriptCommand> commands;
}
