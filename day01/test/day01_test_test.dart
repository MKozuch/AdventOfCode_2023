import 'dart:io';

import 'package:day01/day01.dart';
import 'package:test/test.dart';

void main() {
  test('parseLine', () {
    expect(parseLine("asd1asd2asd3asd"), equals(13));
    expect(parseLine("56943"), equals(53));
    expect(parseLine("5l"), equals(55));
    expect(parseLine("hs7"), equals(77));

    expect(() =>parseLine(''), throwsA(isA<Exception>()));
    expect(() =>parseLine('asd'), throwsA(isA<Exception>()));
  });


  test('preprocessLine1', () {
    expect(preprocessLineNaive("onetwothreezero"), equals("1230"));
    expect(preprocessLineNaive("23krgjlpone"), equals("23krgjlp1"));
    expect(preprocessLineNaive("23krgjlp1"), equals("23krgjlp1"));
    expect(preprocessLineNaive("kfxone67bzb2"), equals("kfx167bzb2"));
    expect(preprocessLineNaive("8jjpseven"), equals("8jjp7"));
    expect(preprocessLineNaive("nineight"), equals("9ight"));
  });

  test('preprocessLine2', () {
    expect(preprocessLine("threeight"), equals("3ight"));
    expect(preprocessLine("threeight1"), equals("3ight1"));
    expect(preprocessLine("onetwothreezero"), equals("1twothree0"));
    expect(preprocessLine("23krgjlpone"), equals("23krgjlp1"));
    expect(preprocessLine("23krgjlp1"), equals("23krgjlp1"));
    expect(preprocessLine("abcone2threexyz"), equals("abc123xyz"));
    expect(preprocessLine("8jjpseven"), equals("8jjp7"));
    expect(preprocessLine("nineight"), equals("9ight"));
    expect(preprocessLine("1fiveight"), equals("1fiv8"));
    expect(preprocessLine("fiveight1"), equals("5ight1"));
    expect(preprocessLine("fiveight"), equals("5ight"));
    expect(preprocessLine("xtwone3four"), equals("x2ne34"));
  });

  test('preprocessLine parseLine integration', () {
    expect(parseLine(preprocessLine("onetwothreezero")), equals(10));
    expect(parseLine(preprocessLine("23krgjlpone")), equals(21));
    expect(parseLine(preprocessLine("23krgjlp1")), equals(21));
    expect(parseLine(preprocessLine("kfxone67bzb2")), equals(12));
    expect(parseLine(preprocessLine("8jjpseven")), equals(87));

    expect(parseLine(preprocessLine("two1nine")), equals(29));
    expect(parseLine(preprocessLine("eightwothree")), equals(83));
    expect(parseLine(preprocessLine("abcone2threexyz")), equals(13));
    expect(parseLine(preprocessLine("xtwone3four")), equals(24));
    expect(parseLine(preprocessLine("4nineeightseven2")), equals(42));
    expect(parseLine(preprocessLine("zoneight234")), equals(14));
    expect(parseLine(preprocessLine("7pqrstsixteen")), equals(76));
  });

  test('processLines', () {
    List<String> lines = [
      "two1nine",
      "eightwothree",
      "abcone2threexyz",
      "xtwone3four",
      "4nineeightseven2",
      "zoneight234",
      "7pqrstsixteen",
    ];
    var total = processList(lines);
    expect(total, equals(281));
  });

}