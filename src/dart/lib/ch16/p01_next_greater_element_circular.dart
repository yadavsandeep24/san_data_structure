// P1: Next greater element, circular
// Source: solutions/ch16/README.md

List<int> nextGreaterCircular(List<int> a) {
  final n = a.length;
  final ans = List<int>.filled(n, -1);
  final stack = <int>[];
  for (var i = 0; i < 2 * n; i++) {
    final x = a[i % n];
    while (stack.isNotEmpty && a[stack.last] < x) {
      ans[stack.removeLast()] = x;
    }
    if (i < n) stack.add(i);
  }
  return ans;
}
