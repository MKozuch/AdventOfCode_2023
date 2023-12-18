import 'package:day08/day08.dart';
import 'dart:io';

void main() {
  final inputFile = File("input/input.txt");
  final lines = inputFile.readAsLinesSync();

  final directionString = lines[0];
  final directions = parseDirectionString(directionString);

  final nodeMapStrings = lines.skip(2);
  final nodeMap = parseNodeMapStrings(nodeMapStrings);

  final startNode = 'AAA';
  final endNode = RegExp('ZZZ');

  var steps = countSteps(startNode, endNode, directions, nodeMap);
  print('Part1 result: $steps');

  final startNode2 = RegExp(r'^\w+A$');
  final endNode2   = RegExp(r'^\w+Z$');
  var steps2 = countStepsParallelOptimised(startNode2, endNode2, directions, nodeMap);
  print('Part2 result: $steps2');
}
