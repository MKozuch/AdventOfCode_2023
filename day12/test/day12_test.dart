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
    expect(SpringListExtension.fromString('').getBadGroupings(), equals([]));
  });

  
}
