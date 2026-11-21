// Q8. Koko Eating Bananas (Minimum Upload Rate)
// Source: book/part-viii/33-stacks-binary-search.md
import 'dart:math';

int minEatingSpeed(List<int> piles, int h) {
  var lo = 1, hi = piles.reduce(max);
  while (lo < hi) {
    final k = lo + (hi - lo) ~/ 2;
    final hours = piles.fold<int>(0, (s, p) => s + (p - 1) ~/ k + 1); // sum of ceil(p / k)
    if (hours <= h) { hi = k; } else { lo = k + 1; }
  }
  return lo;
}
