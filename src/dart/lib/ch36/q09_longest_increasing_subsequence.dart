// Q9. Longest Increasing Subsequence (Longest Rising Streak)
// Source: book/part-viii/36-graphs-dynamic-programming.md

int lengthOfLIS(List<int> nums) {
  final tails = <int>[]; // tails[k] = smallest tail of an increasing run of length k+1
  for (final x in nums) {
    var lo = 0, hi = tails.length;
    while (lo < hi) {
      final mid = (lo + hi) >> 1;
      if (tails[mid] < x) {
        lo = mid + 1;
      } else {
        hi = mid;
      }
    }
    if (lo == tails.length) {
      tails.add(x);
    } else {
      tails[lo] = x;
    }
  }
  return tails.length;
}
