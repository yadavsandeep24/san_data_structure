// Q3 — 3Sum (Swift / Dart)
// Source: solutions/ch32/README.md

List<List<int>> threeSum(List<int> nums) {
  final a = List<int>.of(nums)..sort();
  final out = <List<int>>[];
  for (var i = 0; i < a.length; i++) {
    if (a[i] > 0) break;
    if (i > 0 && a[i] == a[i - 1]) continue;
    var lo = i + 1, hi = a.length - 1;
    while (lo < hi) {
      final sum = a[i] + a[lo] + a[hi];
      if (sum < 0) {
        lo++;
      } else if (sum > 0) {
        hi--;
      } else {
        out.add([a[i], a[lo], a[hi]]);
        lo++;
        hi--;
        while (lo < hi && a[lo] == a[lo - 1]) lo++;
      }
    }
  }
  return out;
}
