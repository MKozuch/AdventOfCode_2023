import 'dart:math';

import 'package:day11/day11.dart';
import 'package:test/test.dart';

void main() {
  test('asColumns', () {
    final arr = [[1, 2, 3],[4,5,6]];
    final rotatedArr = arr.asColumns();
    expect(rotatedArr, equals([[1,4],[2,5],[3,6]]));
  });

  group('description', () {
    late UniverseMap universe;
    setUp(() {
      universe = UniverseMap.fromLines([
        "...#......", // 0
        ".......#..",
        "#.........",
        "..........",
        "......#...", // 4
        ".#........",
        ".........#",
        "..........",
        ".......#..", // 8
        "#...#.....",
      ]);
    });

    test('void indexes', () {
      expect(universe.expandedColumns, equals([2,5,8]));
      expect(universe.expandedLines, equals([3, 7]));
    });
    test('galaxy coords', () {
      expect(universe.galaxies, equals({
        1: (line: 0, column: 3),
        2: (line: 1, column: 7),
        3: (line: 2, column: 0),

        4: (line: 4, column: 6),
        5: (line: 5, column: 1),
        6: (line: 6, column: 9),

        7: (line: 8, column: 7),
        8: (line: 9, column: 0),
        9: (line: 9, column: 4),
      }));
    });

    test('galaxy dist', () {
      expect(calculateDistance(universe.galaxies[5]!, universe.galaxies[9]!, universe.expandedLines, universe.expandedColumns), equals(9));
      expect(calculateDistance(universe.galaxies[9]!, universe.galaxies[5]!, universe.expandedLines, universe.expandedColumns), equals(9));
      expect(calculateDistance(universe.galaxies[1]!, universe.galaxies[7]!, universe.expandedLines, universe.expandedColumns), equals(15));
      expect(calculateDistance(universe.galaxies[3]!, universe.galaxies[6]!, universe.expandedLines, universe.expandedColumns), equals(17));
      expect(calculateDistance(universe.galaxies[8]!, universe.galaxies[9]!, universe.expandedLines, universe.expandedColumns), equals(5));
    });

    test('galaxy dist', () {
      expect(universe.galaxiesDistances[(1,1)], equals(0));
      expect(universe.galaxiesDistances[(5,9)], equals(9));
      expect(universe.galaxiesDistances[(1,7)], equals(15));
      expect(universe.galaxiesDistances[(3,6)], equals(17));
      expect(universe.galaxiesDistances[(8,9)], equals(5));
    });

    test('final answer', () {
      var answer = universe.galaxiesDistances.entries.map((e) => e.value).reduce((value, element) => value+element);
      for(var item in universe.galaxiesDistances.entries){
        print("${item.key.$1} - ${item.key.$2}\t${item.value}");
      }
      expect(answer, equals(374));
    });

  });

}

  