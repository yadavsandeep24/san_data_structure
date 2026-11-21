// Q9 — Longest Increasing Subsequence (Swift / Dart)
// Source: solutions/ch36/README.md

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
