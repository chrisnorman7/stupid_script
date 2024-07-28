// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:math';

import 'package:stupid_script/stupid_script.dart';

const runner = ScriptRunner.withDefaults();

/// The main entry point.
Future<void> main(final List<String> arguments) async {
  final lines = <String>[];
  if (arguments.isEmpty) {
    print('Enter script:');
    var i = 0;
    while (true) {
      stdout.write('Line ${i + 1}> ');
      final line = stdin.readLineSync()?.trim();
      if (line == null || line == '.') {
        break;
      }
      if (line == '?') {
        print('Commands:');
        for (final command in runner.commands) {
          print(command.name);
          print('Arguments:');
          for (final argument in command.arguments) {
            print('${argument.name}: ${argument.description}');
          }
          print('Example:');
          print('```');
          command.example.forEach(print);
          print('```');
        }
        continue;
      }
      i++;
      lines.add(line);
    }
  } else {
    lines.addAll(arguments);
  }
  final random = Random();
  final context = ScriptContext(
    runner: runner,
    random: random,
    variables: {},
  );
  try {
    await context.run(lines);
  } on ScriptError catch (e) {
    print('Error on line ${e.lineNumber + 1}: ${lines[e.lineNumber]}:');
    print(e.exception);
  }
}
