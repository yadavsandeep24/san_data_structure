// P2: Sliding window maximum or level-order
// Source: solutions/ch06/README.md
import 'dart:collection';

List<int> maxSlidingWindow(List<int> nums, int k) {
  if (nums.isEmpty || k <= 0) return [];
  final dq = Queue<int>();
  final res = <int>[];
  for (var i = 0; i < nums.length; i++) {
    while (dq.isNotEmpty && dq.first <= i - k) dq.removeFirst();
    while (dq.isNotEmpty && nums[dq.last] <= nums[i]) dq.removeLast();
    dq.addLast(i);
    if (i >= k - 1) res.add(nums[dq.first]);
  }
  return res;
}
