import 'dart:math';
import 'package:collection/collection.dart';

double logBase(num x, num base) => log(x) / log(base);
double log10(num x) => log(x) / ln10;

enum Spring { good, bad, unknown }

extension SpringExtension on Spring {
  String repr() => switch(this) {
    Spring.good => '.',
    Spring.bad => '#',
    Spring.unknown => '?',
  };

  static Spring fromString(String s) => switch(s) {
    '.' => Spring.good,
    '#' => Spring.bad,
    _ => Spring.unknown,
  };  
}

typedef SpringList = List<Spring>;
extension SpringListExtension on SpringList{
  String repr() => map((e) => e.repr()).join();

  static SpringList fromString(String s){
    return s.split('').map(SpringExtension.fromString).toList();
  }

  List<int> getBadGroupings(){
    List<int> result = [];
    int current = 0;
    for(int i = 0; i < length; i++){
      if(this[i] == Spring.bad){
        current++;
      }else{
        if(current > 0){
          result.add(current);
          current = 0;
        }
      }
    }
    if(current > 0){
      result.add(current);
    }
    return result;
  }
}

Iterable<List<Spring>> generateAllCombinations(int n, int k) sync*{
  var min =  pow(2,k).toInt()-1;
  var max = pow(2,n) - (pow(2,n-k)-1);
  var stopwatch = Stopwatch()..start();
  var yielded = 0;

  for(int i = min; i < max; i++){
    if(i % 10000000 == 0) {
      print("iteration $i \t/ ${max-min} \t time per 10M iterations: ${stopwatch.elapsed} \t yielded: $yielded");
      stopwatch.reset();
      yielded = 0;
    }

    var check = i;
    var pep = 0;
    while(check>0){
      pep += check %2;
      check ~/= 2;
    }
    if(pep!=k) continue;

    final radixString = i.toRadixString(2);
    yielded += 1;
    yield radixString.padLeft(n,'0').split('').map((e) => switch(e) {
      '0' => Spring.good,
      '1' => Spring.bad,
       _ => Spring.unknown,
    }).toList();
  }
}

Iterable<List<T>> generateCombinations<T>(int length, List<T> elements) sync*{
  if(length > 1){
    var newElements = List<T>.from(elements);
    for(final item in elements){
      newElements.remove(item);
      for(var elem in generateCombinations(length-1, newElements)){
        yield  [item, ...elem];
      }
    }
  }
  if(length == 1){
    for(final item in elements){
      yield [item];
    }
  }
}

Iterable<List<Spring>> possibleSubstitutionGenerator(final List<Spring> springList, int totalBadSpringCount) sync*{
  final knownBadSpringsCount = springList.map((e) => e==Spring.bad ? 1: 0).reduce((value, element) => value+element);
  final newBadSpringsCount = totalBadSpringCount - knownBadSpringsCount;

  final unknownCount = springList.where((element) => element == Spring.unknown).length;
  final combinations = generateAllCombinations(unknownCount, newBadSpringsCount);
  for(final combination in combinations){
    int index = 0;
    final newList = springList.map((e) => switch(e) {
      Spring.unknown => combination[index++],
      _ => e,
    }).toList();
    yield newList;
  }
}

bool validate(SpringList list, List<int> groupings){
  return IterableEquality().equals(list.getBadGroupings(), groupings);
}

bool validate2(SpringList list, List<int> groupings){
  int currentGroup = 0;
  int countInGroup = 0;

  Spring currentItem = list[0];
  Spring? prevItem;

  for(final item in list){
    currentItem = item;

    if(prevItem == Spring.bad && currentItem == Spring.good){
      if(currentGroup > groupings.length-1) return false;
      if(countInGroup != groupings[currentGroup]) return false;
      ++currentGroup;
    }

    if(currentItem == Spring.bad) ++countInGroup;
    prevItem = currentItem;
  }

  if(currentItem == Spring.bad){
    if(currentGroup > groupings.length-1) return false;
    if(countInGroup != groupings[currentGroup]) return false;
  }

  return true;
}

int  countValidReplacements(SpringList springList, List<int> groupings){
  final expectedNumberOfBadSprings = groupings.reduce((value, element) => value + element);
  
  int result = 0;
  for(final substitution in possibleSubstitutionGenerator(springList, expectedNumberOfBadSprings)){
    //print('\t${substitution.repr()}');
    if(validate(substitution, groupings)){
      result++;
    }
  }
  return result;
}

(SpringList, List<int>) unfold((SpringList, List<int>) input){
  var expandedSpringList = SpringList.of(input.$1);
  var expandedGroupings = List<int>.of(input.$2);

  for(int i = 0; i<4; i++){
    expandedSpringList.add(Spring.unknown);
    expandedSpringList.addAll(input.$1);

    expandedGroupings.addAll(input.$2);
  }
  return(expandedSpringList, expandedGroupings);
}

int countValidReplacements2(SpringList springList, List<int> groupings){
  final stopwatch = Stopwatch()..start();

  final expectedBadSpringsTotalCount = groupings.reduce((value, element) => value + element);
  final knownBadSpringsCount = springList.map((e) => e==Spring.bad ? 1 : 0).reduce((value, element) => value+element); 
  final unknownSymbolsCount = springList.map((e) => e==Spring.unknown ? 1 : 0).reduce((value, element) => value+element);
  final newBadSpringsCount = expectedBadSpringsTotalCount - knownBadSpringsCount;
  // final expectedIterations = newtonSymbol(unknownSymbolsCount, newBadSpringsCount);

  if(newBadSpringsCount == 0){
    var testSpringList = springList.map((e) => switch(e){
      Spring.unknown => Spring.good,
      _ => e,
    }).toList();
    return validate(testSpringList, groupings) ? 1 : 0;
  }

  List<int> indexList = List<int>.generate(unknownSymbolsCount, (index) => index);
  int result = 0;
  int iteration = 0;
  for(final badSpringIndexes in generateCombinations(newBadSpringsCount, indexList)){
    var replacementBase = List.generate(unknownSymbolsCount, (index) => Spring.good);
    
    for(var idx in badSpringIndexes){
      replacementBase[idx] = Spring.bad;
    }

    int index = 0;
    final testSpringList = 
      springList.map((e) => switch(e) {
        Spring.unknown => replacementBase[index++],
        _ => e}
      ).toList();

    if(validate(testSpringList, groupings)){
      result += 1;
    }

    ++iteration;
    if(iteration % 100000 == 0){
      //print("testing ${testSpringList.repr()}");
      print("iteration number: $iteration \t time: ${stopwatch.elapsed} \t found solutions: ${result}");
      stopwatch.reset();
    }
  }

  return result;
}

int factorial(int x){
  int ret = 1;
  for(int i=1; i<=x; ++i){
    ret *= i;
  }
  return ret;
}

int newtonSymbol(int n, int k){
  return factorial(n) ~/ (factorial(k) * factorial(n-k));
}
