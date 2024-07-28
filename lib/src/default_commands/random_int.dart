import 'dart:math';

import '../commands/script_command.dart';
import '../commands/script_command_argument.dart';
import '../exceptions.dart';
import '../script_context.dart';

/// The random_int command.
class RandomInt extends ScriptCommand {
  /// Create an instance.
  const RandomInt();

  /// The a argument.
  static const ScriptCommandArgument aArgument = ScriptCommandArgument(
    name: 'a',
    description: 'One end of the possible range of numbers.',
  );

  /// The b argument.
  static const bArgument = ScriptCommandArgument(
    name: 'b',
    description: 'One end of the possible range of numbers.',
  );

  /// The arguments of this command.
  @override
  List<ScriptCommandArgument> get arguments => [aArgument, bArgument];

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
  String invoke(
    final ScriptContext scriptContext,
    final Map<String, String> arguments,
  ) {
    final aString = arguments[aArgument.name]!;
    final bString = arguments[bArgument.name]!;
    final a = int.tryParse(aString);
    final b = int.tryParse(bString) ?? 0;
    if (a == null) {
      throw ScriptCommandArgumentError(
        command: this,
        argument: aArgument,
        value: aString,
        message: 'Invalid value.',
      );
    }
    final lower = min(a, b);
    final upper = max(a, b);
    final n = scriptContext.random.nextInt(upper);
    if (lower == 0) {
      return '$n';
    }
    return '${lower + n}';
  }
}
