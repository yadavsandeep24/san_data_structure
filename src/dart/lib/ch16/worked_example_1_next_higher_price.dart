// Worked example 1: next higher price (answer on pop)
// Source: book/part-iv/16-monotonic-stack-deque.md

List<int> nextGreaterValues(List<int> prices) {
  final ans = List<int>.filled(prices.length, -1);
  final stack = <int>[];
  for (var i = 0; i < prices.length; i++) {
    while (stack.isNotEmpty && prices[stack.last] < prices[i]) {
      ans[stack.removeLast()] = prices[i];
    }
    stack.add(i);
  }
  return ans;
}
