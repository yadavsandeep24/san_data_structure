// Q6. Jump Game II (Fewest Deep-Link Hops)
// Source: book/part-viii/35-heaps-tries-greedy.md
import 'dart:math';

int jump(List<int> nums) {
  var jumps = 0;
  var curEnd = 0; // last index reachable with `jumps` jumps
  var farthest = 0; // last index reachable with one more jump
  for (var i = 0; i < nums.length - 1; i++) {
    farthest = max(farthest, i + nums[i]);
    if (i == curEnd) {
      jumps++;
      curEnd = farthest;
    }
  }
  return jumps;
}
