import 'dart:io';

import 'package:args/args.dart';

import 'model_generator.dart';

void main(List<String> arguments){

  final ArgParser argParser = new ArgParser();
  argParser.addOption('input', abbr: 'i', help: "The need to parse json file path");
  argParser.addOption('name', abbr: 'n', help: "The generate class name");
  argParser.addOption('output', abbr: 'o', help: "The result save path");
  argParser.addFlag('help', abbr: 'h', help: "This tool usage manual.", negatable: false);

  final argResults = argParser.parse(arguments);

  if (argResults['help']) {
    print("""
** HELP **
${argParser.usage}
    """);
    return;
  }

  final jsonFile = argResults['input'] as String;

  if (jsonFile == null || jsonFile.isEmpty) {
    return handleError("Missing required argument: input");
  }

  final className = argResults['name'] as String;
  if (className == null || className.isEmpty) {
    return handleError("Missing required argument: className");
  }

  var outputPath = argResults['output'] as String;
  if (outputPath == null || outputPath.isEmpty) {
    outputPath = "./${className}.dart";
  }

  final classGenerator = new ModelGenerator(className);
  final jsonRawData = new File(jsonFile).readAsStringSync();
  DartCode dartCode = classGenerator.generateDartClasses(jsonRawData);
  File(outputPath).writeAsStringSync(dartCode.code);
}

void handleError(String msg) {
  stderr.writeln(msg);
  exitCode = 2; // Two means error
}