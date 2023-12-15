import 'dart:math';

class Card{
  late final int id;
  late final List<int> winningNumbers;
  late final List<int> actualNumbers;

  Card.fromString(String couponString){
    var validator = RegExp(r'^Card\s+\d+:[\d ]+\|[\d ]+$');
    if(!validator.hasMatch(couponString)){
      throw ArgumentError('Invalid coupon string: $couponString');
    }

    String headerString, numbersString, winningNumbersString, actualNumbersString;
    [headerString, numbersString] = couponString.split(':');
    [winningNumbersString, actualNumbersString] = numbersString.split('|');

    id = int.parse(headerString.split(' ').where((element) => element.trim().isNotEmpty).last);

    List<int> strToIntList(String str) {
      return str.trim().split(' ').where((str) => str.trim().isNotEmpty).map((e) => int.parse(e)).toList();
    }

    winningNumbers = strToIntList(winningNumbersString);
    actualNumbers = strToIntList(actualNumbersString);
  }

  int getMatchCount(){
    int matches = 0;
    for(var winningNumber in winningNumbers){
      if(actualNumbers.contains(winningNumber)){
        matches++;
      }
    }
    return matches;
  }

  int getPoints(){
    var points = getMatchCount();
    return points == 0 ? 0 : pow(2, points-1).toInt();
  }
}

typedef CouponList = List<Card>;
typedef CouponMap = Map<int, Card>;
typedef CouponResultList = List<CouponResult>;
typedef CouponResultMap = Map<int, CouponResult>;

class CouponResult{
  final int id;
  final int matches;

  int get points => matches == 0 ? 0 : pow(2, matches).toInt();
  
  List<int> getExtraCoupons() => List<int>.generate(matches, (index) => id + index + 1, growable: false);

  CouponResult(this.id, this.matches );
}

extension CouponListExtension on CouponList{
  CouponResultList getCouponsScore(){
    return map((coupon) => CouponResult(coupon.id, coupon.getMatchCount())).toList();
  }

  int getTotalPoints(){
    return getCouponsScore().map((e) => e.points).reduce((value, element) => value + element);
  }
}

extension CouponMapExtension on CouponMap {
  CouponList getExtraCoupons(List<(int, int)> winningCoupons) {
    var extraCoupons = CouponList.empty(growable: true);
    for (var winningCoupon in winningCoupons) {
      var couponId = winningCoupon.$1;
      var matchCount = winningCoupon.$2;

      var kek = entries
          .where((entry) => (entry.key > couponId && entry.key <= couponId + matchCount))
          .map((e) => e.value);

      assert(kek.length == matchCount);

      extraCoupons.addAll(kek.toList());
    }
    return extraCoupons;
  }
}
