import 'dart:math';

/*
 * Given: totalTime, recordDist;
 * 
 * totalTime = holdingTime + runTime
 * speed = holdingTime
 * dist = speed * runTime
 * dist = holdingTime * (totalTime - holdingTime)
 * holdingTime^2 -totalTime*holdingTime + dist = 0
 * 
 * maxDist = dist(holdingTime == totalTime/2) 
 * 
 * this boild down to calculating how many integers are there between both zero places of this function
 */

/*
Time:        40     82     84     92
Distance:   233   1011   1110   1487

Time:        40828492
Distance:   233101111101487
*/

int possibleWinningTimes(int totalTime, int recordDist){
  final double a = 1;
  final double b = -totalTime.toDouble();
  final double c = recordDist.toDouble();
  
  var delta = pow(b,2) -4*a*c;
  var x1 = (-b-sqrt(delta)) / 2*a;
  var x2 = (-b+sqrt(delta)) / 2*a;
  
  print("min: $x1, max: $x2");
  
  int prevInt(double i){return i == i.toInt() ? i.toInt()-1 : i.floor();};
  int nextInt(double i){return i == i.toInt() ? i.toInt()+1 : i.ceil();};
  
  int minHoldingTime = nextInt(x1);
  int maxHoldingTime = prevInt(x2);
   
  print("min: $minHoldingTime, max: $maxHoldingTime");
  return maxHoldingTime - minHoldingTime +1;
}

void main() {
  assert(possibleWinningTimes(7,9)    == 4);
  assert(possibleWinningTimes(15,40)  == 8);
  assert(possibleWinningTimes(30,200) == 9);

  List<(int,int)> rounds =[
    (40, 233),
    (82, 1011),
    (84, 1119),
    (92, 1482)
  ];

  var res1 = rounds
    .map((round) => possibleWinningTimes(round.$1, round.$2))
    .reduce((value, element) => value * element);
  print("Part1 res: $res1");

  assert(possibleWinningTimes(71530, 940200) == 71503);

  var res2 = possibleWinningTimes(40828492, 233101111191482);
  print("Part2 res: $res2");
}
