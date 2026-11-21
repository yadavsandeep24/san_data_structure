// Q12. Best Time to Buy and Sell Stock with Cooldown (Price Chart Cooldown Rule)
// Source: book/part-viii/36-graphs-dynamic-programming.md
import 'dart:math';

int maxProfit(List<int> prices) {
  var hold = -(1 << 40); // own a share (effectively minus infinity)
  var sold = 0; // sold today (cooldown tomorrow)
  var rest = 0; // no share, free to buy
  for (final p in prices) {
    final prevHold = hold;
    hold = max(hold, rest - p);
    rest = max(rest, sold);
    sold = prevHold + p;
  }
  return max(sold, rest);
}
