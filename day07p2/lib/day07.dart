class Card implements Comparable {
  late int value;
  static final map = Map<String, int>.fromEntries([
    'J',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    'T',
    'Q',
    'K',
    'A'
  ].indexed.map((e) => MapEntry(e.$2, e.$1 + 1)));

  Card.fromString(String str) {
    //assert(RegExp(r'^[0-9TJQKA]$').hasMatch(str));
    assert(map.containsKey(str));
    value = map[str]!;
  }

  @override
  String toString() {
    try {
      return map.entries.firstWhere((element) => element.value == value).key;
    } on StateError {
      return value.toString();
    }
  }

  @override
  bool operator ==(Object other) {
    return other is Card && value == other.value;
  }

  @override
  int compareTo(dynamic other) {
    return value.compareTo(other.value);
  }

  @override
  get hashCode => value;

  bool operator <(Card other) {
    return compareTo(other) < 0;
  }
}

enum HandType { five, four, full, three, twoPairs, onePair, highCard }

class Hand implements Comparable {
  late final List<Card> cardList;
  late final HandType handType;
  late final int bid;

  Hand.fromString(String str) {
    var re = RegExp(r'^(?<cards>[0-9TJQKA]{5}) ?(?<bid>\d+)?');
    var match = re.firstMatch(str);
    assert(match != null);

    bid = int.parse(match?.namedGroup('bid') ?? '0');

    var cardsString = match!.namedGroup('cards')!;
    cardList = cardsString.trim().split('').map(Card.fromString).toList();

    handType = figureHandType();
  }

  @override
  String toString() {
    return cardList.map((e) => e.toString()).join() + ' $bid';
  }

  HandType figureHandType() {
    var counts = <int>[];
    for (var card in Set.from(cardList)) {
      if(card == Card.fromString('J')) continue;

      int count = 0;
      for (var innerCard in cardList) {
        if (card == innerCard) count += 1;
      }
      counts.add(count);
    }

    counts.sort();
    // print(counts);

    final jokerCount = cardList.map((e) => (e.toString() == "J") ? 1:0).reduce((value, element) => value+element);

    var handType = HandType.highCard;

    switch (counts) {
      // no jokers;
      case [5]: handType = HandType.five;
      case [1, 4]: handType = HandType.four;
      case [2, 3]: handType = HandType.full;
      case [1, 1, 3]: handType = HandType.three;
      case [1, 2, 2]: handType = HandType.twoPairs;
      case [1, 1, 1, 2]: handType = HandType.onePair;
      case [1, 1, 1, 1, 1]: handType = HandType.highCard;

      // with 1 jokers
      case [4]: handType = HandType.five;
      case [1, 3]: handType = HandType.four;
      case [2, 2]: handType = HandType.full;
      case [1, 1, 2]: handType = HandType.three;
      case [1, 1, 1, 1]: handType = HandType.onePair;

      // with 2 jokers
      case [3]: handType = HandType.five;
      case [1, 2]: handType = HandType.four;
      case [1, 1, 1]: handType = HandType.three;
      
      // with 3 jokers
      case [2]: handType = HandType.five;
      case [1, 1]: handType = HandType.four;

      // with 4 jokers
      case [1]: handType = HandType.five;

      // only jokers
      case []: handType = HandType.five;
    }

    print("hand $this;\t jokers: $jokerCount;\t counts: $counts;\t type: $handType");    
    return handType;
  }

  operator <(Hand other) {
    if (handType != other.handType) {
      return handType.index > other.handType.index;
    }

    for (int i = 0; i < cardList.length; ++i) {
      if (cardList[i] == other.cardList[i]) continue;
      return cardList[i] < other.cardList[i];
    }
  }

  @override
  int compareTo(dynamic other) {
    if (handType != other.handType) {
      return -1 * handType.index.compareTo(other.handType.index);
    }
    for (int i = 0; i < cardList.length; ++i) {
      if (cardList[i] == other.cardList[i]) continue;
      return cardList[i].compareTo(other.cardList[i]);
    }
    return 0;
  }
}

int playGame(List<Hand> handList) {
  handList.sort((lhs, rhs) => 1 * lhs.compareTo(rhs));
  var result = handList.indexed
      .map((pair) => pair.$2.bid * (pair.$1 + 1))
      .reduce((value, element) => value + element);

  return result;
}
