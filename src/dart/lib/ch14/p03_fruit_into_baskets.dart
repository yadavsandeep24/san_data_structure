// P3: Fruit into baskets (at most two kinds)
// Source: solutions/ch14/README.md

int totalFruit(List<int> types) {
  final count = <int, int>{};
  var left = 0, best = 0;
  for (var right = 0; right < types.length; right++) {
    count[types[right]] = (count[types[right]] ?? 0) + 1;
    while (count.length > 2) {
      final t = types[left];
      final c = count[t]! - 1;
      if (c == 0) {
        count.remove(t);
      } else {
        count[t] = c;
      }
      left++;
    }
    if (right - left + 1 > best) best = right - left + 1;
  }
  return best;
}
