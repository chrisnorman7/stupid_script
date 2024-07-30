import 'dart:math';

import 'package:stupid_script/stupid_script.dart';
import 'package:test/test.dart';

void main() {
  final random = Random();
  const runner = ScriptRunner.withDefaults();
  group(
    'ScriptContext',
    () {
      test(
        'Defaults',
        () {
          final context = ScriptContext(
            runner: runner,
            random: random,
            variables: {
              'undefined': ScriptVariable.undefined(),
            },
            functions: {},
          );
          expect(context.argumentSeparator, '|');
          expect(context.blockEnd, '}');
          expect(context.blockStart, '{');
          expect(context.commandSeparator, ' ');
          expect(context.comment, '#');
          // ignore: avoid_print
          expect(context.outputText, print);
          expect(context.random, random);
          expect(context.runner, runner);
          expect(context.variableBracket, '%');
          expect(context.variables.length, 1);
          expect(context.getVariableValue('undefined'), undefined);
        },
      );
    },
  );
}
