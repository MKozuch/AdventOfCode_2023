import 'dart:ffi';
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

Iterable<SpringList> generatePermutations(int length, int badSpringCount){
    
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