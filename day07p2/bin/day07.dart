import 'dart:io';

import 'package:day07/day07.dart';

void main(List<String> arguments) {
  var file = File('input/input.txt');
  var stringList = file.readAsLinesSync();
  var handList = stringList.map((e) => Hand.fromString(e)).toList();
  var res = playGame(handList);
  print("Part1 result: $res");
}

// 252509916 is too low
// 252509916