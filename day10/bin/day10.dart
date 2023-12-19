import 'package:day10/day10.dart';
import 'dart:io';

void main(List<String> arguments) {
  final file = File('input/input.txt');
  final str = file.readAsStringSync();

  final grid = pipeGridFromString(str);
  final path = traverseGrid(grid);
  final res = path.last.$2;
  print(res/2);
}
