import 'dart:math';

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

List<List<Spring>> generateAllCombinations(int n){
  List<List<Spring>> result = [];
  for(int i = 0; i < pow(2,n); i++){
    result.add(i.toRadixString(2).padLeft(n,'0').split('').map((e) => switch(e) {
      '0' => Spring.good,
      '1' => Spring.bad,
       _ => Spring.unknown,
    }).toList());
  }
  return result;
}