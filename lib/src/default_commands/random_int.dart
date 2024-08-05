import 'dart:math';

import '../commands/arguments/script_command_argument.dart';
import '../commands/arguments/script_command_argument_type.dart';
import '../commands/arguments/script_command_optional_argument.dart';
import '../commands/script_command.dart';
import '../script_context.dart';

/// The random_int command.
class RandomInt extends ScriptCommand<int> {
  /// Create an instance.
  const RandomInt();

  /// The a argument.
  static const ScriptCommandArgument aArgument = ScriptCommandArgument(
    name: 'a',
    description: 'One end of the possible range of numbers.',
    type: ScriptCommandArgumentType.integer,
  );

  /// The b argument.
  static const bArgument = ScriptCommandOptionalArgument(
    name: 'b',
    description: 'One end of the possible range of numbers.',
    type: ScriptCommandArgumentType.integer,
    defaultValue: '0',
  );

  /// The arguments of this command.
  @override
  List<ScriptCommandArgument> get arguments => [aArgument];

  /// Optional arguments.
  @override
  List<ScriptCommandOptionalArgument> get optionalArguments => [bArgument];

  /// Get an example.
  @override
  List<String> get example => [
        '# Generate a random number between 0 and 9:',
        'random 10',
        '# Generate a random number between 1 and 10:',
        'random 1|11',
      ];

  /// The name of this command.
  @override
  String get name => 'random_int';

  /// Generate random numbers.
  @override
  int invoke(
    final ScriptContext scriptContext,
    final Map<String, dynamic> arguments,
  ) {
    final a = arguments[aArgument.name] as int;
    final b = arguments[bArgument.name] as int;
    if (b == 0) {
      return scriptContext.runner.random.nextInt(a);
    }
    final lower = min(a, b);
    final upper = max(a, b);
    final n = scriptContext.runner.random.nextInt(upper);
    if (lower == 0) {
      return n;
    }
    return lower + n;
  }
}
