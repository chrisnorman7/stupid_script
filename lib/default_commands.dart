import 'stupid_script.dart';

/// The default commands which can be recognised by scripts.
const defaultCommands = <ScriptCommand>[
  FunctionCommand(),
  Print(),
  RandomInt(),
  Variable(),
];
