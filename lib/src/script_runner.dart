import 'dart:math';

import '../default_commands.dart';
import 'commands/script_command.dart';
import 'data_type.dart';
import 'default_types/string_data_type.dart';
import 'script_context.dart';
import 'script_function.dart';
import 'script_variable.dart';

/// A class for running scripts.
class ScriptRunner {
  /// Create an instance.
  const ScriptRunner({
    required this.commands,
    required this.types,
  });

  /// Create a default instance.
  const ScriptRunner.withDefaults()
      : commands = defaultCommands,
        types = const [StringDataType()];

  /// The commands to use.
  final List<ScriptCommand> commands;

  /// The map of commands to use.
  Map<String, ScriptCommand> get commandsMap =>
      {for (final command in commands) command.name: command};

  /// The types supported by this runner.
  final List<DataType> types;

  /// The map of types.
  Map<String, DataType<dynamic>> get typesMap =>
      {for (final type in types) type.name: type};

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
