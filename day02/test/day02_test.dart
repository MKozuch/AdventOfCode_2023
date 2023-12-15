import 'dart:math';

import 'package:day02/day02.dart';
import 'package:test/test.dart';

void main() {
  test('line parser', () {
    var game = LineParser.parseGame('Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red');
    expect(game.id, 3);
    expect(game.iterations.length, 3);
    expect(game.iterations[0].boxCounts[BoxType.red], 20);
    expect(game.iterations[0].boxCounts[BoxType.green], 8);
    expect(game.iterations[0].boxCounts[BoxType.blue], 6);
  });

  test('validate game iteration', () {
    var gameIteration = GameIteration(BoxCounts.fromCounts(20, 8, 6));
    var gameRules = GameRules(BoxCounts.fromCounts(1, 1, 1));
    expect(gameIteration.isValid(gameRules), false);

    var gameIteration2 = GameIteration(BoxCounts.fromCounts(20, 8, 6));
    var gameRules2 = GameRules(BoxCounts.fromCounts(21, 9, 7));
    expect(gameIteration2.isValid(gameRules2), true);
  });

  test('get game power', (){
    var rules = GameRules.defaultRules();

    var game1 = LineParser.parseGame('Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green');
    expect(game1.getPower(rules), equals(48));

    var game3 = LineParser.parseGame('Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red');
    expect(game3.getPower(rules), equals(1560));

    var game4 = LineParser.parseGame('Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red');
    expect(game4.getPower(rules), equals(630));    
  });

  test('validate games from strings', (){
    List<String> lines = [
      "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
      "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
      "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
      "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
      "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
    ];

    var rules = GameRules.defaultRules();
    var games = LineParser.parseLines(lines);
    var total = validateGames(games, rules);
    expect(total.idSum, equals(8));
    expect(total.powerSum, equals(2286));
  });
}
