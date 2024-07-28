// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:math';

import 'package:stupid_script/stupid_script.dart';

const runner = ScriptRunner.withDefaults();

/// Pretty print a script [error].
void printScriptError(final String line, final ScriptError error) {
  print('Error on line ${error.lineNumber + 1}: $line:');
  print(error.exception);
}

/// The main entry point.
Future<void> main(final List<String> arguments) async {
  final random = Random();
  if (arguments.isEmpty) {
    final context = ScriptContext(
      runner: runner,
      random: random,
      variables: {},
    );
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
          print('Required Arguments:');
          for (final argument in command.arguments) {
            print('${argument.name}: ${argument.description}');
          }
          if (command.optionalArguments.isNotEmpty) {
            print('Optional Arguments:');
            for (final argument in command.optionalArguments) {
              print('${argument.name}: ${argument.description}');
            }
          }
          print('Example:');
          print('```');
          command.example.forEach(print);
          print('```');
        }
        continue;
      }
      i++;
      try {
        print(await context.handleLine(line));
      } on ScriptError catch (e) {
        printScriptError(line, e);
      }
    }
  } else {
    for (final filename in arguments) {
      final file = File(filename);
      print('Loading $filename...');
      final lines = file.readAsLinesSync();
      final context = ScriptContext(
        runner: runner,
        random: random,
        variables: {
          'filename': filename,
        },
      );
      try {
        await context.run(lines);
      } on ScriptError catch (e) {
        printScriptError(lines[e.lineNumber], e);
      }
    }
  }
}
