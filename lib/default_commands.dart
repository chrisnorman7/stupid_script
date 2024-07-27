import 'src/commands/script_command.dart';
import 'src/default_commands/print.dart';
import 'src/default_commands/random_int.dart';
import 'src/default_commands/variable.dart';

/// The default commands which can be recognised by scripts.
const defaultCommands = <ScriptCommand>[
  Print(),
  RandomInt(),
  Variable(),
];
