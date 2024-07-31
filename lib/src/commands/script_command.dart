import 'dart:async';

import '../script_context.dart';
import 'arguments/script_command_argument.dart';
import 'arguments/script_command_optional_argument.dart';

/// A command which can be called from a script.
abstract class ScriptCommand<T> {
  /// Create an instance.
  const ScriptCommand();

  /// The name of this command.
  ///
  /// The [name] is the command which must be typed in scripts.
  String get name;

  /// An example of how this command should be used.
  List<String> get example;

  /// The function to call when this command is invoked.
  FutureOr<T?> invoke(
    final ScriptContext scriptContext,
    final Map<String, dynamic> arguments,
  );

  /// The arguments this command accepts.
  List<ScriptCommandArgument> get arguments;

  /// The optional arguments.
  List<ScriptCommandOptionalArgument> get optionalArguments;
}
