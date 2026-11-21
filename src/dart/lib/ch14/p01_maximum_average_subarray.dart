// P1: Maximum average subarray
// Source: solutions/ch14/README.md

double findMaxAverage(List<int> nums, int k) {
  var sum = 0;
  for (var i = 0; i < k; i++) {
    sum += nums[i];
  }
  var best = sum;
  for (var r = k; r < nums.length; r++) {
    sum += nums[r] - nums[r - k];
    if (sum > best) best = sum;
  }
  return best / k;
}
