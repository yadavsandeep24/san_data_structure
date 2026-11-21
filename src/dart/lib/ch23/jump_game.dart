// Jump game (mobile-relevant framing)
// Source: book/part-vi/23-greedy-thinking.md

bool canJump(List<int> nums) {
  var farthest = 0;
  for (var i = 0; i < nums.length; i++) {
    if (i > farthest) return false;
    farthest = farthest > i + nums[i] ? farthest : i + nums[i];
    if (farthest >= nums.length - 1) return true;
  }
  return true;
}
