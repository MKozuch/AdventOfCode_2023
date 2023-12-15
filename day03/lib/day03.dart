import 'dart:math';
import 'dart:typed_data';

class Pair<T1, T2> {
  final T1 first;
  final T2 second;

  const Pair(this.first, this.second);

  @override
  String toString() {
    return 'Pair{first: $first, second: $second}';
  }

  @override
  operator ==(Object other) => identical(this, other) || other is Pair && runtimeType == other.runtimeType && first == other.first && second == other.second;
}

class Size extends Pair<int, int> {
  const Size(super.width, super.height);

  int get width => first;
  int get height => second;

  @override
  String toString() {
    return 'Size{width: $width, height: $height}';
  }

  @override
  operator ==(Object other) => identical(this, other);
}

typedef Offset = Point<int>;

class NumberData{
  final int number;
  final Offset pos;
  final String context;

  const NumberData(this.number, this.pos, this.context);

  int get numberSize => (log(number) / ln10).floor() + 1;

  bool isPartNumber(){
    var regex = RegExp(r'^[\d.]+$');
    return !regex.hasMatch(context);
  } 

  @override
  String toString() {
    return 'NumberData{number: $number, pos: $pos, context: $context}';
  }

  @override
  operator ==(Object other) => identical(this, other) || other is NumberData && runtimeType == other.runtimeType && number == other.number && pos == other.pos && context == other.context;
}

class Schematics {
  late final List<String> grid;
  late final Size size;

  String safeGet(Offset pos){
    if(pos.x < 0 || pos.x >= size.height) return '.';
    if(pos.y < 0 || pos.y >= size.width) return '.';
    return grid[pos.x][pos.y];
  }

  Schematics.fromLines(Iterable<String> lines) {
    var lineCout = lines.length;
    var columnCount = lines.map((e) => e.length).reduce(max);
    grid = lines.map((e) => e.padRight(columnCount, '.')).toList(growable: false);
    size = Size(columnCount, lineCout);

    assert(grid.length == lineCout);
    assert(grid.every((element) => element.length == columnCount));
  }

  List<Offset> findNumberPositions(){
    var result = List<Offset>.empty(growable: true);

    for(int lineNumber = 0; lineNumber < size.height; lineNumber++){
      var line = grid[lineNumber];

      var numbersMatches = RegExp(r'(\d+)').allMatches(line);
      for(var match in numbersMatches){
        var pos = Offset(lineNumber, match.start);
        result.add(pos);
      }
    }

    return result;
  }

  Offset adjustOffset(Offset pos){
    if(!RegExp(r'\d').hasMatch(grid[pos.x][pos.y])) return pos;

    while(pos.y > 0 && RegExp(r'\d').hasMatch(grid[pos.x][pos.y-1])) 
    {
      pos = Offset(pos.x, pos.y-1);
    }
    return pos;

  }

  String? figureNumberAtPosition(Offset numberPos){
    var line = grid[numberPos.x];

    var number = RegExp(r'^(\d+)').firstMatch(line.substring(numberPos.y))?.group(0);
    return number;
  }

  List<NumberData> parsePartNumbers(){
    var result = List<NumberData>.empty(growable: true);

    var numberPositions = findNumberPositions();
    for(var numberPos in numberPositions){
      var number = figureNumberAtPosition(numberPos);
      if(number == null) throw Exception('Number not found at $numberPos');
      var context = figureNumberContext(numberPos);
      var numberData = NumberData(int.parse(number), numberPos, context);
      result.add(numberData);
    }

    return result;
  }

  String figureNumberContext(Offset numberPos) {
    var result = List<String>.empty(growable: true);

    var numberAtPos = figureNumberAtPosition(numberPos);
    if(numberAtPos == null) throw Exception('Number not found at $numberPos');

    int left   = numberPos.y - 1;
    int right  = numberPos.y + numberAtPos.length + 1;
    int top    = numberPos.x - 1;
    int bottom = numberPos.x + 1;

    left   = left.clamp(0,   size.width);
    right  = right.clamp(0,  size.width);
    top    = top.clamp(0,    size.height - 1);
    bottom = bottom.clamp(0, size.height - 1);

    for (int lineNumber = top; lineNumber <= bottom; lineNumber++) {
      var line = grid[lineNumber];
      var context = line.substring(left, right);
      result.add(context);
    }

    return result.join();
  }

  List<List<String>> figureGearContext(Offset gearPos){
    int left   = gearPos.y - 1;
    int right  = gearPos.y + 1;
    int top    = gearPos.x - 1;
    int bottom = gearPos.x + 1;

    return[
      [safeGet(Offset(top, left)),       safeGet(Offset(top, gearPos.y)),    safeGet(Offset(top, right))],
      [safeGet(Offset(gearPos.x, left)), safeGet(gearPos),                   safeGet(Offset(gearPos.x, right))],
      [safeGet(Offset(bottom, left)),    safeGet(Offset(bottom, gearPos.y)), safeGet(Offset(bottom, right))],
    ];
  }

  bool isGear(Offset pos){
    var line = grid[pos.x];
    var char = line[pos.y];
    return char == '*';
  }

  List<int> getGearNumbers(Offset gearPos){
    if(!isGear(gearPos)) throw Exception('Not a gear at $gearPos');

    Set<(Offset pos, int number)> parts = {};

    for(var line in [gearPos.x - 1, gearPos.x, gearPos.x + 1]){
      for(var column in [gearPos.y - 1, gearPos.y, gearPos.y + 1]){
        var pos = Offset(line, column);
        if(pos == gearPos) continue;
        
        pos = adjustOffset(pos);
        var number = figureNumberAtPosition(pos);
        if(number != null){
          parts.add((pos, int.parse(number)));
        }
      }
    }

    return parts.map((e) => e.$2).toList(growable: false);
  }

  List<Offset> findGears(){
    var result = List<Offset>.empty(growable: true);

    for(int lineNumber = 0; lineNumber < size.height; lineNumber++){
      for(int column = 0; column < size.width; column++){
        final offset = Offset(lineNumber, column);
        if(isGear(offset)) result.add(offset);
      }
    }
    
    return result;
  }

  List<int> parseGears(){
    var gears = findGears();
    var gearNumbers = gears.map((e) => getGearNumbers(e));
    var meshingGearNumbers = gearNumbers.where((element) => element.length > 1);
    var gearRatios = meshingGearNumbers.map((e) => e.reduce((value, element) => value * element));
    return gearRatios.toList(growable: false);
  }

  int getGearRatioSum(){
    var gearRatios = parseGears();
    return gearRatios.reduce((value, element) => value + element);
  }
}