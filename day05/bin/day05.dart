import 'dart:math';

import 'package:day05/day05.dart';

import "dart:io";

void main(List<String> arguments) {
  var inputFile = File("input/input.txt");
  
  var str = inputFile.readAsStringSync();
  var parts = str.split("\n\n");

  assert(parts.length >= 2);

  var seedNumbers  = parseSeedList(parts[0]);
  print("seed numbers to calculate: ${seedNumbers.length}");

  var mapperList = parts.skip(1)
    .map((part) => part.trim())
    .map((part) => part.split('\n'))
    .map((lines) => Mapper.fromLines(lines))
    .toList();

  var almanac = Almanac.fromMappers(mapperList);

  var seedPositions = seedNumbers.map((seedNumber) => almanac.findSeedPlace(seedNumber));
  
  var minPosition = seedPositions.reduce(min);
  print("closest position: $minPosition");


  print("Part 2");
  final stopwatch = Stopwatch()..start();

  var expectedIterations = 0;
  for(int i = 0; i<seedNumbers.length; i+=2){
    expectedIterations += seedNumbers[i+1];
  }
  expectedIterations = expectedIterations ~/ 1000000;

  int minDist = almanac.findSeedPlace(seedNumbers.first);

  var iterationCount = 0;

  for(int i = 0; i<seedNumbers.length; i+=2){
    var startNumber = seedNumbers[i];
    var seedCount = seedNumbers[i+1];

    for(int currentSeedNo = startNumber; currentSeedNo < startNumber + seedCount; ++currentSeedNo){
      var pos = almanac.findSeedPlace(currentSeedNo);
      if(pos < minDist){
        minDist = pos;
      }

      ++iterationCount;
      if(iterationCount % 1000000 == 0){
        print("iterations done: ${iterationCount ~/ 1000000}M \t out of ${expectedIterations}M  \t current min: $minDist");
      }
    }
  }

   print("closest position: $minDist");
   print('closest positionfound in ${stopwatch.elapsed}');
}