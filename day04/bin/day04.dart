import 'dart:io';

import 'package:day04/day04.dart';

void main(List<String> arguments) {
  print('Advent of Code 2023 - Day 04');
  
  var inputFile = File('input/input.txt');
  var lines = inputFile.readAsLinesSync();
  final CouponList originalCoupons = lines.map((e) => Card.fromString(e)).toList();
  final CouponResultMap precomputedCouponResults = { for (var e in originalCoupons.getCouponsScore()) e.id : e }; 

  var totalPoints = originalCoupons.getTotalPoints();
  print('Original score points: $totalPoints');


  print('Part 2:');
  int totalCoupons = originalCoupons.length;

  CouponResultList currentCouponResults = [];
  List<int> currentExtraCouponIds = [];

  // iteration 0
  currentCouponResults = originalCoupons.getCouponsScore();
  currentExtraCouponIds = currentCouponResults.expand((element) => element.getExtraCoupons()).toList();
  totalCoupons += currentExtraCouponIds.length;

  while(currentExtraCouponIds.isNotEmpty){
    currentCouponResults = currentExtraCouponIds.map((e) => precomputedCouponResults[e]!).toList();
    currentExtraCouponIds = currentCouponResults.expand((element) => element.getExtraCoupons()).toList();
    totalCoupons += currentExtraCouponIds.length;
  }

  print('Total coupon count: $totalCoupons');

}
