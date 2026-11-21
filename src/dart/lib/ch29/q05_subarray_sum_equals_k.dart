// Q5. Subarray Sum Equals K
// Source: book/part-viii/29-interview-questions-q01-q10.md

int subarraySum(List<int> nums, int k) {
  final freq = <int, int>{0: 1};
  var sum = 0, ans = 0;
  for (final x in nums) {
    sum += x;
    ans += freq[sum - k] ?? 0;
    freq[sum] = (freq[sum] ?? 0) + 1;
  }
  return ans;
}
