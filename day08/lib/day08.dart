import 'dart:math';

enum Direction { left, right }

typedef Directions = List<Direction>;

Directions parseDirectionString(String str) {
  assert(RegExp('[RL]+').hasMatch(str));

  Directions directions = [];
  for (var item in str.split('')) {
    switch (item) {
      case 'L':
        directions.add(Direction.left);
      case 'R':
        directions.add(Direction.right);
      case _:
        continue;
    }
  }

  return directions;
}

typedef NodeMap = Map<String, ({String left, String right})>;
NodeMap parseNodeMapStrings(Iterable<String> list) {
  // AAA = (BBB, CCC)
  var re = RegExp(r'^(?<from>\w+) = \((?<left>\w+), (?<right>\w+)\)$');

  NodeMap nodeMap = {};

  for (final line in list) {
    var match = re.firstMatch(line);
    assert(match != null);

    final from = match!.namedGroup('from')!;
    final left = match.namedGroup('left')!;
    final right = match.namedGroup('right')!;

    nodeMap[from] = (left: left, right: right);
  }

  return nodeMap;
}

String nextNode(String currentNode, Direction direction, NodeMap nodeMap) {
  return switch (direction) {
    Direction.left => nodeMap[currentNode]!.left,
    Direction.right => nodeMap[currentNode]!.right
  };
}

int countSteps(final String startNode, final RegExp endNode,
    final Directions directions, final NodeMap nodeMap) {
  var currentNode = startNode;
  int currentIteration = 0;

  while (!endNode.hasMatch(currentNode)) {
    final direction = directions[currentIteration % directions.length];
    currentNode = nextNode(currentNode, direction, nodeMap);
    currentIteration++;
    if (currentIteration % 1000000 == 0)
      print("currentIteration $currentIteration");
  }

  return currentIteration;
}

int traverse(final RegExp startNode, final RegExp endNode,
    final Directions directions, final NodeMap nodeMap) {
  // start from startNode
  // traverse until endNode
  //
  return 0;
}

int countStepsParallelNaive(final RegExp startNode, final RegExp endNode,
    final Directions directions, final NodeMap nodeMap) {
  final List<String> startNodes =
      nodeMap.keys.where((element) => startNode.hasMatch(element)).toList();

  var currentNodes = List<String>.of(startNodes);
  int currentIteration = 0;
  while (currentNodes.any((element) => !endNode.hasMatch(element))) {
    final direction = directions[currentIteration % directions.length];
    currentNodes =
        currentNodes.map((e) => nextNode(e, direction, nodeMap)).toList();
    currentIteration++;

    if (currentIteration % 1000000 == 0)
      print("currentIteration $currentIteration");
  }

  return currentIteration;
}

int countStepsParallelOptimised(final RegExp startNode, final RegExp endNode,
    final Directions directions, final NodeMap nodeMap) {
  final List<String> startNodes =
      nodeMap.keys.where((element) => startNode.hasMatch(element)).toList();

  List<int> steps = startNodes
      .map((node) => countSteps(node, endNode, directions, nodeMap))
      .toList();

  //find lcm of steps list apparently every path is cyclic and wraps around afer finish node
  return lcm(steps);
}

int lcm(final List<int> numbers_) {
  var numbers = List<int>.of(numbers_);

  var maxNumber = numbers.reduce(max);
  var primes = primesUpTo(maxNumber);
  List<int> factors = [];

  for (var prime in primes) {
    while (numbers.any((n) => n % prime == 0)) {
      factors.add(prime);
      numbers = numbers.map((n) => n % prime == 0 ? n ~/ prime : n).toList();
    }
  }

  assert(numbers.every((element) => element == 1));
  final asd = factors.fold(1, (a, b) => a * b);
  return asd;
}

List<int> primesUpTo(int n) {
  var primes = <int>[];
  var sieve = List<bool>.filled(n + 1, true);
  for (var i = 2; i <= n; i++) {
    if (sieve[i]) {
      primes.add(i);
      for (var j = i * i; j <= n; j += i) {
        sieve[j] = false;
      }
    }
  }
  return primes;
}
