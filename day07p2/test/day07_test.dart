import 'dart:math';

import 'package:day07/day07.dart';
import 'package:test/test.dart';

void main() {

group('asdf', () {
  test('card ctor', () {
    expect(Card.fromString('2').value, equals(2));
    expect(Card.fromString('T').value, equals(10));
    expect(Card.fromString('J').value, equals(1));
    expect(Card.fromString('A').value, equals(13));
  });

  test('card compare', () {
    expect(Card.fromString('2') < Card.fromString('3'), equals(true));
    expect(Card.fromString('K') == Card.fromString('K'), equals(true));
  });

  test('hand ctor', () {
    expect(Hand.fromString('KK399 948').toString(),
        equals('KK399 948'));
    expect(Hand.fromString('QJ828 791').toString(), equals('QJ828 791'));
    expect(Hand.fromString('97697 211').toString(), equals('97697 211'));
    expect(Hand.fromString('KKK6J 719').toString(), equals('KKK6J 719'));
  });

  test('figure hand type', () {
    expect(Hand.fromString('AAAAA').handType, equals(HandType.five));
    expect(Hand.fromString('AA8AA').handType, equals(HandType.four));
    expect(Hand.fromString('23332').handType, equals(HandType.full));
    expect(Hand.fromString('TTT98').handType, equals(HandType.three));
    expect(Hand.fromString('23432').handType, equals(HandType.twoPairs));
    expect(Hand.fromString('A23A4').handType, equals(HandType.onePair));
    expect(Hand.fromString('23456').handType, equals(HandType.highCard));

    expect(Hand.fromString('T55J5').handType, equals(HandType.four));
    expect(Hand.fromString('KTJJT').handType, equals(HandType.four)); 
  });

  test('compare hands', () {
    expect(Hand.fromString('AAAAA').compareTo(Hand.fromString('AAAAA')), equals(0));
    expect(Hand.fromString('AAAAA').compareTo(Hand.fromString('22222')), equals(1));
    expect(Hand.fromString('22222').compareTo(Hand.fromString('AAAAA')), equals(-1));
    expect(Hand.fromString('AAAAA').compareTo(Hand.fromString('23456')), equals(1));
  });

  test('play game', () {
    var stringList = [
      "32T3K 765",
      "T55J5 684",
      "KK677 28 ",
      "KTJJT 220",
      "QQQJA 483",
    ];
    var handList = stringList.map((str) => Hand.fromString(str)).toList();

    expect(playGame(handList), equals(5905));
  });

  });
}
