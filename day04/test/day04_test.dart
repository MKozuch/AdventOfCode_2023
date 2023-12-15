import 'dart:math';

import 'package:day04/day04.dart';
import 'package:test/test.dart';

void main() {
  test('parse coupon', () {
    var coupon = Card.fromString("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53");
    expect(coupon.id, 1);
    expect(coupon.winningNumbers, [41, 48, 83, 86, 17]);
    expect(coupon.actualNumbers, [83, 86, 6, 31, 17, 9, 48, 53]);
  });

  group('integration', (){
    late List<Card> couponList;

    setUp((){
      var lines = [
        "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
        "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
        "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
        "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
        "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
        "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11",
      ];
      couponList = lines.map((e) => Card.fromString(e)).toList();
    });

    test('get points', () {
      expect(couponList[0].getPoints(), 8);
      expect(couponList[1].getPoints(), 2);
      expect(couponList[2].getPoints(), 2);
      expect(couponList[3].getPoints(), 1);
      expect(couponList[4].getPoints(), 0);
      expect(couponList[4].getPoints(), 0);
    });

    test('e2e ', () {
      final CouponResultMap precomputedCouponResults = { for (var e in couponList.getCouponsScore()) e.id : e }; 
      var totalCoupons = couponList.length;
      List<int> couponsPerIteration = [];
      couponsPerIteration.add(couponList.length);

      CouponResultList currentCouponResults = [];
      List<int> extraCouponIds = [];

      // iteration 0
      currentCouponResults = couponList.getCouponsScore();
      extraCouponIds = currentCouponResults.expand((element) => element.getExtraCoupons()).toList();
      totalCoupons += extraCouponIds.length;
      couponsPerIteration.add(extraCouponIds.length);

      while(extraCouponIds.isNotEmpty){
        currentCouponResults = extraCouponIds.map((e) => precomputedCouponResults[e]!).toList();
        extraCouponIds = currentCouponResults.expand((element) => element.getExtraCoupons()).toList();
        totalCoupons += extraCouponIds.length;
        couponsPerIteration.add(extraCouponIds.length);
      }

      expect(totalCoupons, 30 );
    });


  });

}
