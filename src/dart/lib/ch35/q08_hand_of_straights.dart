// Q8. Hand of Straights (Consecutive Ticket Batches)
// Source: book/part-viii/35-heaps-tries-greedy.md

bool isNStraightHand(List<int> hand, int groupSize) {
  if (hand.length % groupSize != 0) return false;
  final count = <int, int>{};
  for (final h in hand) {
    count[h] = (count[h] ?? 0) + 1;
  }
  final keys = count.keys.toList()..sort();
  for (final first in keys) {
    final need = count[first] ?? 0; // groups that must start here
    if (need == 0) continue;
    for (var v = first; v < first + groupSize; v++) {
      final have = count[v] ?? 0;
      if (have < need) return false;
      count[v] = have - need;
    }
  }
  return true;
}
