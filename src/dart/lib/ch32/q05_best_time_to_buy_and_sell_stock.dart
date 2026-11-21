// Q5. Best Time to Buy and Sell Stock (One-Trade Profit)
// Source: book/part-viii/32-two-pointers-windows-intervals.md
import 'dart:math';

int maxProfit(List<int> prices) {
  int? minSoFar;
  var best = 0;
  for (final p in prices) {
    if (minSoFar == null || p < minSoFar) {
      minSoFar = p;
    } else {
      best = max(best, p - minSoFar);
    }
  }
  return best;
}
