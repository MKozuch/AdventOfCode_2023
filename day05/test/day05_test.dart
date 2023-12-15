import 'package:day05/day05.dart';
import 'package:test/test.dart';

void main() {
  
  test('mapping item ctor', (){
    var asd = MappingItem.fromString("4042213712 4061491177 216624499");
    expect(asd.targerStart, equals(4042213712));
    expect(asd.sourceStart, equals(4061491177));
    expect(asd.rangeLength, equals(216624499));
  });

  test('parse seed numbers', (){
    var str = 'seeds: 79 14 55 13';
    var list = parseSeedList(str);
    expect(list, equals([79, 14, 55, 13]));
  }); 

  test('expand seed list', (){
    var seedList = [0, 1, 6, 4];
    var list = expandSeedList(seedList);
    expect(list, equals([0, 6, 7, 8, 9]));
  }); 


  group('basic mapper', () {

    late final Mapper mapper;

    setUpAll(() {
      mapper = Mapper.fromLines([
        "seed-to-soil map:",
        "50 98 2",
        "52 50 48",
      ]);
    });


    test('test 1', () {
      expect(mapper.itemList[0], equals(MappingItem.fromString("52 50 48")));
      expect(mapper.itemList[1], equals(MappingItem.fromString("50 98 2")));
      expect(mapper.name, equals('seed-to-soil'));
    });

    test('test 2', () {
      expect(mapper.map(0), equals(0));
      expect(mapper.map(49), equals(49));
      expect(mapper.map(50), equals(52));
      expect(mapper.map(51), equals(53));
      expect(mapper.map(52), equals(54));
      expect(mapper.map(98), equals(50));
      expect(mapper.map(99), equals(51));
      expect(mapper.map(100), equals(100));
    });

  });


  
  group('e2e', () {

    late final Almanac almanac;

    setUp(() {
      var seed_to_soil_mapper = Mapper.fromLines([
        "50 98 2",
        "52 50 48",
      ]);

      var soil_to_fertilizer_mapper = Mapper.fromLines([
        "0 15 37", 
        "37 52 2", 
        "39 0 15"]);

      var fertilizer_to_water_mapper = Mapper.fromLines([
        "49 53 8",
        "0 11 42",
        "42 0 7",
        "57 7 4",
      ]);

      var water_to_light_mapper = Mapper.fromLines([
        "88 18 7",
        "18 25 70",
      ]);

      var light_to_temperature_mapper = Mapper.fromLines([
        "45 77 23",
        "81 45 19",
        "68 64 13",
      ]);

      var temperature_to_humidity_mapper = Mapper.fromLines([
        "0 69 1",
        "1 0 69",
      ]);

      var humidity_to_location_mapper = Mapper.fromLines([
        "60 56 37",
        "56 93 4",
      ]);

      almanac = Almanac.fromMappers([
        seed_to_soil_mapper,
        soil_to_fertilizer_mapper,
        fertilizer_to_water_mapper,
        water_to_light_mapper,
        light_to_temperature_mapper,
        temperature_to_humidity_mapper,
        humidity_to_location_mapper,
      ]);
    });


    test('test 1', () {
        List<int> seeds = [79, 14, 55, 13];
        List<int> locations = seeds.map((seedNumber) => almanac.findSeedPlace(seedNumber)).toList();
        expect(locations, equals([82, 43, 86, 35]));

    });

  });
}
