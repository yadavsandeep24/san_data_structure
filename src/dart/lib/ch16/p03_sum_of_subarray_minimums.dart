// P3: Sum of subarray minimums
// Source: solutions/ch16/README.md

int sumSubarrayMins(List<int> a) {
  const mod = 1000000007;
  final stack = <int>[];
  var total = 0;
  for (var i = 0; i <= a.length; i++) {
    final cur = i == a.length ? -1 << 62 : a[i];
    while (stack.isNotEmpty && a[stack.last] >= cur) {
      final j = stack.removeLast();
      final k = stack.isEmpty ? -1 : stack.last;
      total = (total + a[j] * (j - k) * (i - j)) % mod;
    }
    stack.add(i);
  }
  return total;
}
