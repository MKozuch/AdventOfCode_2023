import 'package:day08/day08.dart';
import 'package:test/test.dart';

void main() {
  test('test1', () {
    final directions = parseDirectionString('RL');
    final nodeMap = parseNodeMapStrings([
      "AAA = (BBB, CCC)",
      "BBB = (DDD, EEE)",
      "CCC = (ZZZ, GGG)",
      "DDD = (DDD, DDD)",
      "EEE = (EEE, EEE)",
      "GGG = (GGG, GGG)",
      "ZZZ = (ZZZ, ZZZ)",
    ]);
    final startNode = 'AAA';
    final endNode = RegExp('ZZZ');

    final steps = countSteps(startNode, endNode, directions, nodeMap);
    expect(steps, equals(2));
  });

  test('test2', () {
    final directions = parseDirectionString('LLR');
    final nodeMap = parseNodeMapStrings([
      "AAA = (BBB, BBB)",
      "BBB = (AAA, ZZZ)",
      "ZZZ = (ZZZ, ZZZ)",
    ]);
    final startNode = 'AAA';
    final endNode = RegExp('ZZZ');

    final steps = countSteps(startNode, endNode, directions, nodeMap);
    expect(steps, equals(6));
  });

  test('test3', () {
    final directions = parseDirectionString('LR');
    final nodeMap = parseNodeMapStrings([
      "11A = (11B, XXX)",
      "11B = (XXX, 11Z)",
      "11Z = (11B, XXX)",
      "22A = (22B, XXX)",
      "22B = (22C, 22C)",
      "22C = (22Z, 22Z)",
      "22Z = (22B, 22B)",
      "XXX = (XXX, XXX)",
    ]);
    final startNode = RegExp(r'^\w+A$');
    final endNode   = RegExp(r'^\w+Z$');

    final steps = countStepsParallelNaive(startNode, endNode, directions, nodeMap);
    expect(steps, equals(6));
  });
}
