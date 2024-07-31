import 'dart:math';

import '../default_commands.dart';
import 'commands/script_command.dart';
import 'script_context.dart';
import 'script_function.dart';
import 'script_variable.dart';

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

  /// Run the lines of [script].
  Future<void> runScript(
    final List<String> script, {
    final Random? random,
    final List<ScriptVariable> variables = const [],
    final List<ScriptFunction>? functions,
  }) async {
    final context = ScriptContext(
      runner: this,
      random: random ?? Random(),
      variables: {for (final variable in variables) variable.name: variable},
      functions: functions ?? [],
    );
    return context.run(script);
  }
}
