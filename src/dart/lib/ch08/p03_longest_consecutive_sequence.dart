// P3: Longest consecutive sequence
// Source: solutions/ch08/README.md

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
    best = len > best ? len : best;
  }
  return best;
}
