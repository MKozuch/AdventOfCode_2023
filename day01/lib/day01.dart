// Purpose: Day 1 of Advent of Code 2023

import 'dart:io';

String strToNum(String? str){
  switch(str){
      case 'one': return '1';
      case 'two': return '2';
      case 'three': return '3';
      case 'four': return '4';
      case 'five': return '5';
      case 'six': return '6';
      case 'seven': return '7';
      case 'eight': return '8';
      case 'nine': return '9';
      case 'zero': return '0';
    }
    return str ?? '';
}

String preprocessLineNaive(String line) {
  line = line.replaceAllMapped(
      RegExp(r'one|two|three|four|five|six|seven|eight|nine|zero'), 
      (match){
        return strToNum(match.group(0));
      }
  );
  return line;
}

String preprocessLine(String line) {
    line = line.replaceAllMapped(
      RegExp(r'^(?:[a-z]*?)(one|two|three|four|five|six|seven|eight|nine|zero)(?:[0-9a-z]*)$'), 
      (match){
        return match.group(0)!.replaceAll(match.group(1)!, strToNum(match.group(1)));
      }
    );
    line = line.replaceAllMapped(
      RegExp(r'^(?:[0-9a-z]*)(one|two|three|four|five|six|seven|eight|nine|zero)(?:[a-z]*?)$'), 
      (match){
        return match.group(0)!.replaceAll(match.group(1)!, strToNum(match.group(1)));
      }
    );

    return line;
}

int parseLine(String line) {
  var firstNumberRe = RegExp(r'^(?:[a-zA-z]*)([0-9])');
  var lastNumberRe = RegExp(r'([0-9])(?:[a-zA-z]*$)');

  String? firstMatch = firstNumberRe.firstMatch(line)?.group(1);
  String? lastMatch = lastNumberRe.firstMatch(line)?.group(1);

  if(firstMatch == null || lastMatch == null ) {
    throw Exception('Could not parse line: $line');
  }

  String numberStr = firstMatch + lastMatch;

  var value = int.parse(numberStr);
  assert(value >= 0 && value <= 99);

  return value;
}

int processList(List<String> lines) {
  int total = 0;

  for (var line in lines) {
    try {
      total += parseLine(preprocessLine(line));
      print("$line, ${preprocessLine(line)}, ${parseLine(preprocessLine(line))}, $total");

    } catch (e) {
      print(e);
      throw Exception('Could not parse line: $line');
    }
  }
  return total;
}


void main(List<String> arguments) {
  var myFile = File('input/input.txt');
  var lines = myFile.readAsLinesSync();
  var total = processList(lines);
  print(total);
}
