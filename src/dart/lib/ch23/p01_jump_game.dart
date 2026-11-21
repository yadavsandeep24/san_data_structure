// P1: Jump game
// Source: solutions/ch23/README.md

bool canJump(List<int> nums) {
  var farthest = 0;
  for (var i = 0; i < nums.length; i++) {
    if (i > farthest) return false;
    final reach = i + nums[i];
    if (reach > farthest) farthest = reach;
    if (farthest >= nums.length - 1) return true;
  }
  return true;
}
