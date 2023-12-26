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
    expect(countValidReplacements(SpringListExtension.fromString('??'),[2]), equals(1));
    expect(countValidReplacements(SpringListExtension.fromString('?###????????'), [3,2,1]), equals(10));
  });

  test('unfold', () {
    var exp1 = unfold((SpringListExtension.fromString('.#'), [1]));
    expect(exp1.$1.repr(), equals('.#?.#?.#?.#?.#'));
    expect(exp1.$2, equals([1,1,1,1,1]));
  });

  test('generatePermutations', (){
    var lst1 = generateCombinations(3, [1,2,3,4]).toList();
    expect(lst1.length, 4);
    for(var kek in lst1) {
      print(kek);
    }

    print('');
    var lst2 = generateCombinations(3, [1,2,3,4,5]);
    expect(lst2.length, 10);
    for(var kek in lst2) {
      print(kek);
    }
   });

  test('cound replacements', () {
   expect(countValidReplacements2(SpringListExtension.fromString('?'),[1]), equals(1));
   expect(countValidReplacements2(SpringListExtension.fromString('??'),[2]), equals(1));
   expect(countValidReplacements2(SpringListExtension.fromString('.???.###'), [1,1,3]), equals(1));
   expect(countValidReplacements2(SpringListExtension.fromString('.??..??...?##.'), [1,1,3]), equals(4));
   expect(countValidReplacements2(SpringListExtension.fromString('?#?#?#?#?#?#?#?'), [1,3,1,6]), equals(1));
   expect(countValidReplacements2(SpringListExtension.fromString('????.#...#...'), [4,1,1]), equals(1));
   expect(countValidReplacements2(SpringListExtension.fromString('????.######..#####.'), [1,6,5]), equals(4));
   expect(countValidReplacements2(SpringListExtension.fromString('?###????????'), [3,2,1]), equals(10));
   expect(countValidReplacements2(SpringListExtension.fromString('?.#?.#???#'), [1,1,1]), equals(1));
  });

  test('timing1', (){
    List<int> indexList = List<int>.generate(49, (index) => index);
    var newBadSpringsCount = 40;
    List<int> current;

    var iterationsMax = 100000;
    var currentIt = 0;

    var stopwatch = Stopwatch()..start();
    for(var item in generateCombinations(newBadSpringsCount, indexList)){
      current = item;
      if(currentIt == iterationsMax){
        break;
      }
      current[0];
      ++currentIt;
    }
    print(stopwatch.elapsed);
  });

    test('timing2', (){
      final springList = SpringListExtension.fromString('#.##.###.####.#####.######.#######.########.#########.##########');
      final groupings = [1,2,3,4,5,6,7,8,9,10];
      final maxIterations = 10000000;

      final stopwatch = Stopwatch()..start();
      for(int i = 0; i<maxIterations; ++i){
        validate(springList, groupings);
      }
      print("vlidate: ${stopwatch.elapsed}");
    
      stopwatch.reset();
      for(int i = 0; i<maxIterations; ++i){
        validate(springList, groupings);
      }
      print("vlidate2: ${stopwatch.elapsed}");
    });

    test('validate2', (){
      expect(validate(SpringListExtension.fromString("#.##.###.####.#####.######.#######.########.#########.##########"), [1,2,3,4,5,6,7,8,9,10]), true);
      expect(validate(SpringListExtension.fromString(".#.##.###.####.#####.######.#######.########.#########.##########."), [1,2,3,4,5,6,7,8,9,10]), true);
      expect(validate(SpringListExtension.fromString("#.##.###.####.#####.######.#######.########.#########.##########"), [1,2,3,4,5,6,7,8,9]), false);
      expect(validate(SpringListExtension.fromString("#.##.###.####.#####.######.#######.########.#########.##########"), [1,2,3,4,5,6,7,8,9,10,11]), false);
      expect(validate(SpringListExtension.fromString("####"), [4]), true);
    });

  test('cound replacements 3', () {
      expect(countValidReplacements3(SpringListExtension.fromString('?'),[1]), equals(1));
      expect(countValidReplacements3(SpringListExtension.fromString('??'),[2]), equals(1));
      expect(countValidReplacements3(SpringListExtension.fromString('.???.###'), [1,1,3]), equals(1));
      expect(countValidReplacements3(SpringListExtension.fromString('.??..??...?##.'), [1,1,3]), equals(4));
      expect(countValidReplacements3(SpringListExtension.fromString('?#?#?#?#?#?#?#?'), [1,3,1,6]), equals(1));
      expect(countValidReplacements3(SpringListExtension.fromString('????.#...#...'), [4,1,1]), equals(1));
      expect(countValidReplacements3(SpringListExtension.fromString('????.######..#####.'), [1,6,5]), equals(4));
      expect(countValidReplacements3(SpringListExtension.fromString('?###????????'), [3,2,1]), equals(10));
      expect(countValidReplacements3(SpringListExtension.fromString('?.#?.#???#'), [1,1,1]), equals(1));
  });
}