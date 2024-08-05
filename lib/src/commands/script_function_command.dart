import 'dart:async';

import '../../stupid_script.dart';
import 'arguments/script_command_optional_argument.dart';

/// A function which has been converted to a command.
class ScriptFunctionCommand implements ScriptCommand {
  /// Create an instance.
  const ScriptFunctionCommand(this.scriptFunction);

  /// The script command to use.
  final ScriptFunction scriptFunction;

  /// The arguments to use.
  @override
  List<ScriptCommandArgument> get arguments => scriptFunction.arguments;

  /// Try and show an example.
  @override
  List<String> get example => [
        '$name ${arguments.map(
              (final e) => e.name,
            ).join('|')}'
      ];

  /// Invoke this command.
  @override
  Future<String?> invoke(
    final ScriptContext scriptContext,
    final Map<String, dynamic> arguments,
  ) async {
    final variables = <String, ScriptVariable>{};
    for (final variable in scriptContext.variables.values) {
      variables[variable.name] = variable;
    }
    for (final MapEntry(key: name, value: value) in arguments.entries) {
      variables[name] = ScriptVariable(
        name: name,
        type: scriptContext.runner.getValueType(value),
        value: value,
      );
    }
    final subContext = ScriptContext(
      runner: scriptContext.runner,
      variables: variables,
      functions: scriptContext.functions,
    );
    await subContext.handleLines(scriptFunction.lines);
    return null;
  }

//// Return the function name.
  @override
  String get name => scriptFunction.name;

  /// Return an empty list.
  @override
  List<ScriptCommandOptionalArgument> get optionalArguments => [];
}
