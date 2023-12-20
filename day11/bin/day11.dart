import 'package:day11/day11.dart';
import 'dart:io';

void main(List<String> arguments) {
  final file = File('input/input.txt');
  final lines = file.readAsLinesSync();

  final universeMap = UniverseMap.fromLines(lines);
  final answer = universeMap.galaxiesDistances.entries.map((e) => e.value).reduce((value, element) => value+element);
  print("Part 1 answer: $answer");

  final largeUniverseMap = UniverseMap.fromLines(lines, expansionMultiplier: 1000000);
  final largeAnswer = largeUniverseMap.galaxiesDistances.entries.map((e) => e.value).reduce((value, element) => value+element);
  print("Part 2 answer: $largeAnswer");
}

// 9514757 too low