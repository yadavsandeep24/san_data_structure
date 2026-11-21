// Q3 — Largest rectangle in histogram (Swift / Dart)
// Source: solutions/ch33/README.md
import 'dart:math';

int largestRectangleArea(List<int> heights) {
  final stack = <int>[]; // indices, heights increasing
  var best = 0;
  for (var i = 0; i <= heights.length; i++) {
    final h = i == heights.length ? 0 : heights[i]; // sentinel flushes the stack
    while (stack.isNotEmpty && heights[stack.last] >= h) {
      final height = heights[stack.removeLast()];
      final left = stack.isEmpty ? -1 : stack.last;
      best = max(best, height * (i - left - 1));
    }
    stack.add(i);
  }
  return best;
}
