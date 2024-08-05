import 'dart:math';

import 'package:stupid_script/stupid_script.dart';
import 'package:test/test.dart';

void main() {
  final random = Random();
  final runner = ScriptRunner.withDefaults(random: random);
  group(
    'ScriptContext',
    () {
      test(
        'Defaults',
        () {
          final context = ScriptContext(
            runner: runner,
            variables: {},
            functions: [],
          );
          expect(context.runner, runner);
          expect(context.variables, isEmpty);
          expect(context.getVariableValue('undefined'), undefined);
        },
      );
    },
  );
}
