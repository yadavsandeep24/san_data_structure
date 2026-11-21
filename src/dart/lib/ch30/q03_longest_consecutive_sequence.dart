// Q3. Longest Consecutive Sequence
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

int longestConsecutive(List<int> nums) {
  final set = nums.toSet();
  var best = 0;
  for (final x in set) {
    if (set.contains(x - 1)) continue;
    var y = x, len = 1;
    while (set.contains(y + 1)) {
      y++;
      len++;
    }
    if (len > best) best = len;
  }
  return best;
}
