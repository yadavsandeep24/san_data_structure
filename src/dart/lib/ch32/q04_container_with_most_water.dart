// Q4. Container With Most Water (Widest Chart Band)
// Source: book/part-viii/32-two-pointers-windows-intervals.md
import 'dart:math';

int maxArea(List<int> height) {
  var i = 0;
  var j = height.length - 1;
  var best = 0;
  while (i < j) {
    best = max(best, (j - i) * min(height[i], height[j]));
    if (height[i] < height[j]) {
      i++;
    } else {
      j--;
    }
  }
  return best;
}
