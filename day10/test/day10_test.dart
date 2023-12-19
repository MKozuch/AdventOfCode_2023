import 'package:day10/day10.dart';
import 'package:test/test.dart';

void main() {
  test('traverse grid', () {
    var grid = pipeGridFromString(
      "7-F7-\n"
      ".FJ|7\n"
      "SJLL7\n"
      "|F--J\n"
      "LJ.LJ\n"
    );

    var path = traverseGrid(grid);
    expect(path.last.$2 ~/2, equals(4));
  });

    test('traverse grid 2', () {
    var grid = pipeGridFromString(
      "..F7.\n"
      ".FJ|.\n"
      "SJ.L7\n"
      "|F--J\n"
      "LJ...\n"
    );

    var path = traverseGrid(grid);
    expect(path.last.$2 ~/2, equals(8));
  });
}
