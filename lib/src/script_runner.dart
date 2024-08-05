import 'dart:math';

import 'package:csv/csv.dart';

import '../default_commands.dart';
import '../default_types.dart';
import 'commands/script_command.dart';
import 'data_type.dart';
import 'exceptions.dart';
import 'script_context.dart';
import 'script_function.dart';
import 'script_variable.dart';

/// A class for running scripts.
class ScriptRunner {
  /// Create an instance.
  const ScriptRunner({
    required this.commands,
    required this.types,
    required this.random,
    this.comment = '#',
    this.commandSeparator = ' ',
    this.variableBracket = '%',
    this.blockStart = '{',
    this.blockEnd = '}',
    this.functionEnd = 'end',
    this.converter = const CsvToListConverter(shouldParseNumbers: false),
  });

  /// Create a default instance.
  const ScriptRunner.withDefaults({
    required this.random,
    this.comment = '#',
    this.commandSeparator = ' ',
    this.variableBracket = '%',
    this.blockStart = '{',
    this.blockEnd = '}',
    this.functionEnd = 'end',
    this.converter = const CsvToListConverter(shouldParseNumbers: false),
  })  : commands = defaultCommands,
        types = defaultTypes;

  /// The commands to use.
  final List<ScriptCommand> commands;

  /// The types supported by this runner.
  final List<DataType> types;

  /// The map of types.
  Map<String, DataType<dynamic>> get typesMap =>
      {for (final type in types) type.name: type};

  /// The character(s) which signify the start of a comment..
  final String comment;

  /// The random number generator to use.
  final Random random;

  /// The character which separates a command from its arguments.
  final String commandSeparator;

  /// The characters to surround variable names for expansion.
  final String variableBracket;

  /// The character which starts an embedded script block.
  final String blockStart;

  /// The character which ends an embedded script block.
  final String blockEnd;

  /// The string which signifies the end of a function.
  final String functionEnd;

  /// The CSV converter to use.
  final CsvToListConverter converter;

  /// Run the lines of [script].
  Future<void> runScript(
    final List<String> script, {
    final List<ScriptVariable> variables = const [],
    final List<ScriptFunction>? functions,
  }) async {
    final context = ScriptContext(
      runner: this,
      variables: {for (final variable in variables) variable.name: variable},
      functions: functions ?? [],
    );
    return context.handleLines(script);
  }

  /// Get the type of [value].
  DataType getValueType(final dynamic value) {
    for (final type in types) {
      if (type.valueMatches(value)) {
        return type;
      }
    }
    throw UnknownType(value);
  }
}
