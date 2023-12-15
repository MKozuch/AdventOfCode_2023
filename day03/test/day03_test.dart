import 'dart:math';

import 'package:day03/day03.dart';
import 'package:test/test.dart';

void main() {
  late Schematics schematics;

  group('basic', () {
    setUp(() {
      schematics = Schematics.fromLines([
        '123......',
        '.',
        '.12.89.',
      ]);
    });

    test('schematics parse', () {
      expect(schematics.size.height, equals(3));
      expect(schematics.size.width, equals(9));

      expect(
          schematics.grid,
          equals([
            '123......',
            '.........',
            '.12.89...',
          ]));
    });

    test('schematics getNumberPos', () {
      var numberPositions = schematics.findNumberPositions();
      expect(
          numberPositions,
          containsAll([
            Point(0, 0),
            Point(2, 1),
            Point(2, 4),
          ]));
    });
  });


  group('adv', (){
    late Schematics schematics;
    setUp((){
      schematics = Schematics.fromLines([
        r"467..114..",
        r"...*......",
        r"..35..633.",
        r"......#...",
        r"617*......",
        r".....+.58.",
        r"..592.....",
        r"......755.",
        r"...$.*....",
        r".664.598..",
      ]);
    });

    test('findNumbers', (){
      var numberPositions = schematics.findNumberPositions();
      expect(numberPositions, containsAll([
        Offset(0, 0),
        Offset(0, 5),
        Offset(2, 2),
        Offset(2, 6),
      ]));
    });

    test('findNumberAtPos', (){
      expect(schematics.figureNumberAtPosition(Offset(0, 0)), equals('467'));
      expect(schematics.figureNumberAtPosition(Offset(0, 5)), equals('114'));
      expect(schematics.figureNumberAtPosition(Offset(2, 2)), equals('35'));
      expect(schematics.figureNumberAtPosition(Offset(2, 6)), equals('633'));
    });

    test('findNumberSurrondingsFlat', (){
      expect(schematics.figureNumberContext(Offset(0, 1)), equals("467." 
                                                                        "...*"));

      expect(schematics.figureNumberContext(Offset(0, 5)), equals(".114." 
                                                                        "....."));

      expect(schematics.figureNumberContext(Offset(2, 2)), equals("..*."
                                                                        ".35."
                                                                        "...." ));

      expect(schematics.figureNumberContext(Offset(2, 6)), equals("....."
                                                                        ".633."
                                                                        ".#..."));
    });

    test('parse', (){
      var numbers = schematics.parsePartNumbers();

      expect(numbers, containsAll([
        NumberData(467, Offset(0, 0), "467." 
                                      "...*"),

        NumberData(114, Offset(0, 5), ".114." 
                                      "....."),

        NumberData(35, Offset(2, 2),  "..*."
                                      ".35."
                                      "...." ),

        NumberData(633, Offset(2, 6), "....."
                                      ".633."
                                      ".#..."),
      ]));
    });

    });


    group('gears', (){
    late Schematics schematics;
    setUp((){
      schematics = Schematics.fromLines([
        r"467..114..",
        r"...*......",
        r"..35..633.",
        r"......#...",
        r"617*......",
        r".....+.58.",
        r"..592.....",
        r"......755.",
        r"...$.*....",
        r".664.598..",
      ]);
    });

    test('findGears', (){
      var gears = schematics.findGears();
      expect(gears, containsAll([
        Offset(1, 3),
        Offset(8, 5),
        Offset(4, 3),
      ]));
    });

    test('getGearNumbers', (){
      expect(schematics.getGearNumbers(Offset(1,3)), unorderedEquals([467, 35]));
      expect(schematics.getGearNumbers(Offset(4,3)), unorderedEquals([617]));
      expect(schematics.getGearNumbers(Offset(8,5)), unorderedEquals([755, 598 ]));
    });


    });
}
