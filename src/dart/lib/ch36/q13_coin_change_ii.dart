// Q13. Coin Change II (Ways to Make Change at the Till)
// Source: book/part-viii/36-graphs-dynamic-programming.md

int change(int amount, List<int> coins) {
  final ways = List<int>.filled(amount + 1, 0);
  ways[0] = 1;
  for (final coin in coins) { // coins outer => combinations, not orderings
    for (var a = coin; a <= amount; a++) {
      ways[a] += ways[a - coin];
    }
  }
  return ways[amount];
}
