import 'package:day11/day11.dart';
import 'dart:io';

void main(List<String> arguments) {
  final file = File('input/input.txt');
  final lines = file.readAsLinesSync();
  final universeMap = UniverseMap.fromLines(lines);
  final answer = universeMap.galaxiesDistances.entries.map((e) => e.value).reduce((value, element) => value+element);
  print(answer);
}

// 9514757 too low