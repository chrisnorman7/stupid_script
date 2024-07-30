import 'dart:async';

import '../../stupid_script.dart';
import 'script_command_optional_argument.dart';

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
      final ScriptCommandArgumentType type;
      if (value is int) {
        type = ScriptCommandArgumentType.integer;
      } else if (value is double) {
        type = ScriptCommandArgumentType.float;
      } else if (value is String || value == undefined) {
        type = ScriptCommandArgumentType.string;
      } else {
        throw UnimplementedError(
          'This should not happen. Tried to find type of variable $name '
          'is $value (${value.runtimeType}).',
        );
      }
      variables[name] = ScriptVariable(name: name, type: type, value: value);
    }
    final subContext = ScriptContext(
      runner: scriptContext.runner,
      random: scriptContext.random,
      variables: variables,
      functions: scriptContext.functions,
      argumentSeparator: scriptContext.argumentSeparator,
      blockEnd: scriptContext.blockEnd,
      blockStart: scriptContext.blockStart,
      commandSeparator: scriptContext.commandSeparator,
      comment: scriptContext.comment,
      functionEnd: scriptContext.functionEnd,
      outputText: scriptContext.outputText,
      variableBracket: scriptContext.variableBracket,
    );
    await subContext.run(scriptFunction.lines);
    return null;
  }

//// Return the function name.
  @override
  String get name => scriptFunction.name;

  /// Return an empty list.
  @override
  List<ScriptCommandOptionalArgument> get optionalArguments => [];
}
