import 'dart:math';

import 'package:day12/day12.dart';
import 'package:test/test.dart';

void main() {
  test('springlist conversions', () {
    expect([Spring.good, Spring.bad, Spring.unknown].repr(), equals('.#?'));
    expect(SpringList.empty().repr(), equals(''));

    expect(SpringListExtension.fromString('.#?'), equals([Spring.good, Spring.bad, Spring.unknown]));
    expect(SpringListExtension.fromString(''), equals([]));
  });

  test('calc grouping', () {
    expect(SpringListExtension.fromString('.#..##...###.####').getBadGroupings(), equals([1,2,3,4]));
    expect(SpringListExtension.fromString('#####').getBadGroupings(), equals([5]));
    expect(SpringListExtension.fromString('...').getBadGroupings(), equals([]));
    expect(SpringListExtension.fromString('.').getBadGroupings(), equals([]));
    expect(SpringListExtension.fromString('#').getBadGroupings(), equals([1]));
    expect(SpringListExtension.fromString('').getBadGroupings(), equals([]));
  });

  test('generateAllCombination', () {
    expect(generateAllCombinations(3,2), equals([
      [Spring.good, Spring.bad, Spring.bad],
      [Spring.bad, Spring.good, Spring.bad],
      [Spring.bad, Spring.bad, Spring.good],
    ]));
  });

  test('possibleSubstitutionGenerator', () {
    expect(possibleSubstitutionGenerator(SpringListExtension.fromString('.??.'),1), containsAll([
      SpringListExtension.fromString('.#..'),
      SpringListExtension.fromString('..#.'),
    ]));
  });

  test('checkAllPossibilities', () {
    expect(countValidReplacements(SpringListExtension.fromString('?'),[1]), equals(1));
  //  expect(countValidReplacements(SpringListExtension.fromString('?'),[]), equals(1));
    expect(countValidReplacements(SpringListExtension.fromString('??'),[2]), equals(1));
    expect(countValidReplacements(SpringListExtension.fromString('?###????????'), [3,2,1]), equals(10));
  });

  test('unfold', () {
    var exp1 = unfold((SpringListExtension.fromString('.#'), [1]));
    expect(exp1.$1.repr(), equals('.#?.#?.#?.#?.#'));
    expect(exp1.$2, equals([1,1,1,1,1]));
  });

}
