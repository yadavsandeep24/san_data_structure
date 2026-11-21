// Pattern: longest consecutive sequence
// Source: book/part-iii/08-sets.md

int longestConsecutive(List<int> nums) {
  final set = nums.toSet();
  var best = 0;
  for (final x in set) {
    if (set.contains(x - 1)) continue;
    var y = x;
    var len = 1;
    while (set.contains(y + 1)) {
      y++;
      len++;
    }
    if (len > best) best = len;
  }
  return best;
}
