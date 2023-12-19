enum Pipe {ground, vertical, horizontal, ne, nw, sw, se, start}

Pipe pipeFromString(String str){
  switch(str){
    case '.': return Pipe.ground;
    case '|': return Pipe.vertical;
    case '-': return Pipe.horizontal;
    case 'L': return Pipe.ne;
    case 'J': return Pipe.nw;
    case '7': return Pipe.sw;
    case 'F': return Pipe.se;
    case 'S': return Pipe.start;
    case _: throw Exception('Unknown pipe symbol: $str');
  }
}

typedef Position = ({int line, int column});
typedef Vector = ({int horizontal, int vertical});

typedef PipeGrid = List<List<Pipe>>;

PipeGrid pipeGridFromString(final String str){
  PipeGrid grid = [];
  for(var line in str.split('\n')){
    grid.add(line.split('').map(pipeFromString).toList());
  }
  return grid;
}
extension PipeGridExtension on PipeGrid{
  Pipe atPos(final Position pos){
    try{
      return this[pos.line][pos.column];
    }
    on RangeError{
      return Pipe.ground;
    } 
  }
}

Position findStartPos(final PipeGrid grid){
  for(var line = 0; line<grid.length; ++line){
    final idx = grid[line].indexOf(Pipe.start);
    if( idx >= 0) return (line: line, column: idx);
  }
  throw Exception('Could not find start pos');
}

List<Vector> possibleOutputsFromPipe(final Pipe pipe){
  switch(pipe){
    case Pipe.horizontal: return[(horizontal: -1, vertical:  0), (horizontal:  1, vertical:  0)];
    case Pipe.vertical:   return[(horizontal:  0, vertical: -1), (horizontal:  0, vertical:  1)];
    case Pipe.ne:         return[(horizontal:  0, vertical: -1), (horizontal:  1, vertical:  0)];
    case Pipe.nw:         return[(horizontal:  0, vertical: -1), (horizontal: -1, vertical:  0)];
    case Pipe.sw:         return[(horizontal:  0, vertical:  1), (horizontal: -1, vertical:  0)];
    case Pipe.se:         return[(horizontal:  0, vertical:  1), (horizontal:  1, vertical:  0)];
    case _: throw Exception('Unsupported pipe type');
  }
}

Position figureFirstStep(final Position currentPos, final PipeGrid grid){

  final topPos = (line: currentPos.line-1, column: currentPos.column);
  final atTop = grid.atPos(topPos);
  if([Pipe.vertical, Pipe.sw, Pipe.se].contains(atTop)) return topPos;

  final leftPos = (line: currentPos.line, column: currentPos.column-1);
  final atLeft = grid.atPos(leftPos);
  if([Pipe.horizontal, Pipe.ne, Pipe.se].contains(atLeft)) return leftPos;

  final rightPos = (line: currentPos.line, column: currentPos.column +1);
  final atRight = grid.atPos(rightPos);
  if([Pipe.horizontal, Pipe.nw, Pipe.sw].contains(atRight)) return rightPos;

  final bottomPos = (line: currentPos.line+1, column: currentPos.column);
  final atBottom = grid.atPos(bottomPos);
  if([Pipe.vertical, Pipe.nw, Pipe.ne].contains(atBottom)) return bottomPos;

  throw Exception('Could not determine first step');
}

Position getNextPos(final PipeGrid grid, final Position previousPos, final Position currentPos){
  if(grid.atPos(currentPos) == Pipe.start){
    return figureFirstStep(currentPos, grid);
  }
  final possibleSteps = possibleOutputsFromPipe(grid.atPos(currentPos))
    .map((e) => (line: currentPos.line + e.vertical, column: currentPos.column + e.horizontal))
    .toList();

  final idx = possibleSteps.indexWhere((element) => element != previousPos);
  return possibleSteps[idx];
}

List<(Position, int)> traverseGrid(PipeGrid grid){
  final startPos = findStartPos(grid);
  List<(Position, int)> result = [];
  result.add((startPos, 0));

  var currentPos = figureFirstStep(startPos, grid);
  var previousPos = startPos;
  int dist = 1;
  result.add((currentPos, dist++));

  do{
    var nextPos = getNextPos(grid, previousPos, currentPos);
    result.add((currentPos, dist++));
    previousPos = currentPos;
    currentPos = nextPos;

    print("curentPos: $currentPos, dist: $dist");
  }while(currentPos != startPos);

  return result;
}