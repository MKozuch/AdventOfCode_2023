import 'dart:io';

import 'package:day02/day02.dart';

void main() {
  var file = File('input/input.txt');
  var lines = file.readAsLinesSync();

  var rules = GameRules.defaultRules();
  var games = LineParser.parseLines(lines);
  var total = validateGames(games, rules);
  print("${total.idSum}");
  print("${total.powerSum}");
}
