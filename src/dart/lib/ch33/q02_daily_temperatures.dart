// Q2. Daily Temperatures (Warmer-Day Countdown)
// Source: book/part-viii/33-stacks-binary-search.md

List<int> dailyTemperatures(List<int> temps) {
  final ans = List<int>.filled(temps.length, 0);
  final stack = <int>[]; // indices, temperatures strictly decreasing
  for (var i = 0; i < temps.length; i++) {
    while (stack.isNotEmpty && temps[stack.last] < temps[i]) {
      final j = stack.removeLast();
      ans[j] = i - j;
    }
    stack.add(i);
  }
  return ans;
}
