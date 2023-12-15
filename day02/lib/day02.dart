
import 'dart:math';

enum BoxType{
  red,
  green,
  blue
}

class BoxCounts{
  Map<BoxType, int> boxCounts = Map<BoxType, int>();

  BoxCounts(this.boxCounts);
  BoxCounts.fromCounts(int red, int green, int blue){
    boxCounts[BoxType.red] = red;
    boxCounts[BoxType.green] = green;
    boxCounts[BoxType.blue] = blue;
  }

  int operator [](BoxType boxType) => boxCounts[boxType]!;
  void operator []=(BoxType boxType, int value) => boxCounts[boxType] = value;
}

class GameRules {
  BoxCounts boxCounts;
  GameRules(this.boxCounts);

  GameRules.defaultRules() : boxCounts = BoxCounts({
      BoxType.red: 12,
      BoxType.green: 13,
      BoxType.blue: 14
    });
}

class GameIteration{
  BoxCounts boxCounts;
  GameIteration(this.boxCounts);

  bool isValid(GameRules rules){
    return BoxType.values.every((element) => boxCounts[element] <= rules.boxCounts[element]);
  }
}

class Game{
  int id;
  List<GameIteration> iterations;

  Game(this.id) : iterations = List.empty();

  bool isValid(GameRules rules){
    return iterations.every((element) => element.isValid(rules));
  }

  void addIteration(GameIteration iteration){
    iterations.add(iteration);
  }

  void addIterations(List<GameIteration> iterationlst){
    iterations += iterationlst;
  }

  int getPower(GameRules rules){
    var redPower   = iterations.map((e) => e.boxCounts[BoxType.red]).where((element) => element > 0).reduce(max);
    var greenPower = iterations.map((e) => e.boxCounts[BoxType.green]).where((element) => element > 0).reduce(max);
    var bluePower  = iterations.map((e) => e.boxCounts[BoxType.blue]).where((element) => element > 0).reduce(max);
    return redPower * greenPower * bluePower;
  }
}

class LineParser{
  static Iterable<Game> parseLines(Iterable<String> lines){
    return lines.map((e) => parseGame(e));
  }

  static Game parseGame(String line){
    String gameStr, iterationsStr;
    [gameStr, iterationsStr] = line.split(':');
    
    var gameNumberRegex = RegExp(r'^(?:Game\s)(\d+)');
    var gameNumber = int.parse(gameNumberRegex.firstMatch(gameStr)!.group(1)!);
    var game = Game(gameNumber);

    var iterations = parseGameIterations(iterationsStr);
    game.addIterations(iterations);

    return game;
  }

  static List<GameIteration> parseGameIterations(String line){
    var gameIterationRegex = RegExp(r'((?:[a-z0-9\s,]+)+);?');
    var gameIterationMatches = gameIterationRegex.allMatches(line);
    var gameIterations = gameIterationMatches.map((e) => parseGameIterationSingle(e.group(1)!)).toList();
    return gameIterations;
  }

  static GameIteration parseGameIterationSingle(String line){
    var redCountRegex   = RegExp(r'(\d+)\sred');
    var greenCountRegex = RegExp(r'(\d+)\sgreen');
    var blueCountRegex  = RegExp(r'(\d+)\sblue');

    var redCountMatch   = redCountRegex.firstMatch(line);
    var greenCountMatch = greenCountRegex.firstMatch(line);
    var blueCountMatch  = blueCountRegex.firstMatch(line);

    var redCount   = int.parse(redCountMatch?.group(1) ?? '0');
    var greenCount = int.parse(greenCountMatch?.group(1) ?? '0');
    var blueCount  = int.parse(blueCountMatch?.group(1) ?? '0');

    var boxCounts = BoxCounts.fromCounts(redCount, greenCount, blueCount);
    return GameIteration(boxCounts);
  }
}

class GameValidationSummary{
  int idSum = 0;
  int powerSum = 0;
}

GameValidationSummary validateGames(Iterable<Game> games, GameRules rules){
  var validGames = games.where((element) => element.isValid(rules));
  var validGameIds = validGames.map((e) => e.id);
  var allGamePowers = games.map((e) => e.getPower(rules));

  var idSum = validGameIds.reduce((value, element) => value + element);
  var powerSum = allGamePowers.reduce((value, element) => value + element);
  return GameValidationSummary()..idSum = idSum..powerSum = powerSum;
}

GameValidationSummary validateGamesFromString(Iterable<String> lines, GameRules rules){
  return validateGames(LineParser.parseLines(lines), rules);
}