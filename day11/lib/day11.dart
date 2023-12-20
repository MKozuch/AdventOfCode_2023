import 'dart:math';

enum UniverseItem{nothing, galaxy}
final universeItemStringMap = {'.': UniverseItem.nothing, '#': UniverseItem.galaxy};

List<UniverseItem> stringToUniverseItemList(line) => line.split('').map<UniverseItem>((e) => universeItemStringMap[e]!).toList();

bool isVoidOfSpace(Iterable<UniverseItem> lst) => lst.every((element) => element == UniverseItem.nothing);

typedef UniverseGrid = List<List<UniverseItem>>;

extension UniverseGridExtension on UniverseGrid{
  List<int> findVoidLines() => indexed
      .where((pair) => isVoidOfSpace(pair.$2))
      .map((e) => e.$1)
      .toList()..sort();

  Map<int, UniverseCoord> findGalaxies(){
    List<UniverseCoord> galaxies = [];
    for(var(lineNumber, line) in indexed){
      for(var(columnNumber, item) in line.indexed){
        if(item == UniverseItem.galaxy) galaxies.add((line: lineNumber, column: columnNumber));
      }
    }
    return Map.fromEntries(galaxies.indexed.map((e) => MapEntry(e.$1+1, e.$2)));
  }
}

extension ListListExtension<T> on List<List<T>>{
  List<List<T>> asColumns(){
      return first.indexed.map((pair) => pair.$1)
        .map((index) => map((e) => e[index]).toList()
      ).toList();
    }
}


typedef UniverseCoord = ({int line, int column});
int manhattanDist(UniverseCoord p1, UniverseCoord p2){
  return (p2.column-p1.column).abs() + (p2.line-p1.line).abs();
}

int calculateDistance(final UniverseCoord p1, final UniverseCoord p2, final List<int> expandedLines, final List<int> expandedColumns, {final int expansionMultiplier = 2}){

  final (left, right) = (min(p1.column, p2.column), max(p1.column, p2.column));
  final passingThroughExpandedColumnsCount = 
    expandedColumns.where((element) => element > left && element < right)
    .length;
  
  final (up, down) = (min(p1.line, p2.line), max(p1.line, p2.line));
  final passingThroughExpandedLinesCount = 
    expandedLines.where((element) => element > up && element < down)
    .length;

  return manhattanDist(p1, p2) + (passingThroughExpandedLinesCount + passingThroughExpandedColumnsCount)*(expansionMultiplier-1);
}


class UniverseMap{
  late UniverseGrid internalUniverse;
  late List<int> expandedLines;
  late List<int> expandedColumns;
  late Map<int, UniverseCoord> galaxies;
  late Map<(int, int), int> galaxiesDistances;

  UniverseMap.fromLines(Iterable<String> lines, {final int expansionMultiplier = 2}){
    assert(lines.isNotEmpty);
    assert(lines.every((element) => RegExp(r'^[\.#]+$').hasMatch(element)));
    final width = lines.first.length;
    assert(lines.every((element) => element.length == width));

    internalUniverse = lines.map(stringToUniverseItemList).toList();

    expandedLines = internalUniverse.findVoidLines();
    expandedColumns = internalUniverse.asColumns().findVoidLines();

    galaxies = internalUniverse.findGalaxies();

    galaxiesDistances = {};
    for(final lhs in galaxies.entries){
      for(final rhs in galaxies.entries){
        if(rhs.key < lhs.key) continue;

        galaxiesDistances[(lhs.key, rhs.key)] = calculateDistance(lhs.value, rhs.value, expandedLines, expandedColumns, expansionMultiplier: expansionMultiplier);
      }
    }
  }
}