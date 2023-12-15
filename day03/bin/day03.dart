import 'package:day03/day03.dart';
import 'dart:io';


void main(){
  var file = File('input/input.txt');
  var lines = file.readAsLinesSync();
  var schematics = Schematics.fromLines(lines);
  var sum = schematics.parsePartNumbers().where((element) => element.isPartNumber()).map((e) => e.number).reduce((value, element) => value + element);
  print(sum);

  var sum2 = schematics.getGearRatioSum();
  print(sum2);
}
