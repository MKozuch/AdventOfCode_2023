
class MappingItem implements Comparable<MappingItem>{
  MappingItem.fromString(String str){
    var re = RegExp(r'^(?<target>\d+)\s+(?<source>\d+)\s+(?<length>\d+)$');
    assert(re.hasMatch(str));
    var match = re.firstMatch(str)!;

    targerStart = int.parse(match.namedGroup('target')!);
    sourceStart = int.parse(match.namedGroup('source')!);
    rangeLength = int.parse(match.namedGroup('length')!);
  }

  late int targerStart;
  late int sourceStart;
  late int rangeLength;

  @override
  String toString() {
    return "MappingItem{targerStart: $targerStart, sourceStart: $sourceStart, rangeLength: $rangeLength}";
  }

  @override
  int compareTo(MappingItem other) {
    return sourceStart.compareTo(other.sourceStart);
  }

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is MappingItem &&
      runtimeType == other.runtimeType &&
      targerStart == other.targerStart &&
      sourceStart == other.sourceStart &&
      rangeLength == other.rangeLength;
}

class Mapper{
  late final List<MappingItem> itemList;
  late final String? name;

  Mapper.fromLines(Iterable<String> lines){
    var re = RegExp(r'^(?<mappername>[a-z\-]+) map:$');
    var match = re.firstMatch(lines.first);
    if(match != null){
      name = match.namedGroup('mappername');
      lines = lines.skip(1);
    }

    itemList = lines
      .map((line) => MappingItem.fromString(line))
      .toList();

      itemList.sort();
  }

  int map(int source){
    var idx = itemList.indexWhere((item) => item.sourceStart <= source && source < item.sourceStart + item.rangeLength);
    if(idx == -1){
      return source;
    }

    var item = itemList[idx];
    return (source - item.sourceStart) + item.targerStart;
  }
}

class Almanac{
  List<Mapper> mapperList = [];

  Almanac.fromMappers(this.mapperList);

  int findSeedPlace(int seedNumber){
    var value = seedNumber;

    for(Mapper mapper in mapperList){
      value = mapper.map(value);
    }

    return value;
  }
}

List<int> parseSeedList(String str){
  str = str.trim();
  var re = RegExp(r'^seeds: (?<seednumbers>[0-9 ]+)$');
  assert(re.hasMatch(str));

  var seedNumbersStr = re.firstMatch(str)!.namedGroup('seednumbers')!;

  var seedNumbers = seedNumbersStr.split(' ')
    .map((e) => e.trim())
    .map((e) => int.parse(e))
    .toList();

  return seedNumbers;
}

Iterable<int> expandSeedList(List<int> initialList){
  assert(initialList.length % 2 == 0);

  var expandedList = List<int>.empty();

  for(int i = 0; i<initialList.length; i+=2){
    var startPos = initialList[i];
    var len = initialList[i+1];

    var kek = List<int>.generate(len, (index) => startPos + index);
    expandedList += kek;
  }
  return expandedList;
}