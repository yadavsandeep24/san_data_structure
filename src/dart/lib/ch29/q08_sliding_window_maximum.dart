// Q8. Sliding Window Maximum (Scroll Velocity)
// Source: book/part-viii/29-interview-questions-q01-q10.md

List<int> maxSlidingWindow(List<int> nums, int k) {
  final dq = <int>[];
  var head = 0;
  final out = <int>[];
  for (var i = 0; i < nums.length; i++) {
    while (head < dq.length && dq[head] <= i - k) head++;
    while (head < dq.length && nums[dq.last] <= nums[i]) dq.removeLast();
    dq.add(i);
    if (i >= k - 1) out.add(nums[dq[head]]);
  }
  return out;
}
