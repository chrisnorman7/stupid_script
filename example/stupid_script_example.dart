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
      functions: [],
    );
    print('Enter script:');
    var i = 0;
    while (true) {
      stdout.write('Line ${i + 1}');
      final function = context.scriptFunction;
      if (function != null) {
        stdout.write(' (${function.name})# ');
      } else {
        stdout.write('> ');
      }
      final line = stdin.readLineSync()?.trim();
      if (line == null || line == '.') {
        break;
      }
      if (line == '?') {
        print('Commands:');
        for (final command in context.getAllCommands) {
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
      try {
        print(await context.handleLine(line));
        i++;
      } on Exception catch (e) {
        print(e);
      }
    }
  } else {
    for (final filename in arguments) {
      final file = File(filename);
      print('Loading $filename...');
      final script = file.readAsLinesSync();
      try {
        await runner.runScript(
          script,
          random: random,
          variables: [
            ScriptVariable(
              name: 'filename',
              type: ScriptCommandArgumentType.string,
              value: filename,
            ),
          ],
        );
      } on ScriptError catch (e) {
        printScriptError(script[e.lineNumber], e);
      }
    }
  }
}
