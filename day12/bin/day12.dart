import 'package:day12/day12.dart';
import 'dart:io';


void main() {
  final file = File("input/input.txt");
  final lines = file.readAsLinesSync();

  List<(SpringList, List<int>)> input = [];
  input = lines.map((e){
    var parts = e.split(' ');
    final springList = SpringListExtension.fromString(parts[0]);
    final groupings = parts[1].split(',').map((e) => int.parse(e)).toList();
    return (springList, groupings);
  }).toList();

  final stopwatch = Stopwatch()..start();

  // int total = 0;
  // for(final inputItem in input){
  //   final springList = inputItem.$1;
  //   final groupings = inputItem.$2;
  //   total += countValidReplacements(springList, groupings); 
  // }
  // print("Part 1 solution: $total");
  // print('"Part 1 executed in ${stopwatch.elapsed}');

  stopwatch.reset();
  int total2 = 0;
  for(final inputItem in input){
    late SpringList springList;
    late List<int> groupings;

    (springList, groupings) = unfold(inputItem);
    print('checking line ${springList.repr()}');
    total2 += countValidReplacements(springList, groupings); 
  }
  print("Part 2 solution: $total2");
  print('"Part 2 executed in ${stopwatch.elapsed}');
}
