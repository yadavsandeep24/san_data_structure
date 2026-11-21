// Q18. Binary Search
// Source: book/part-viii/29-interview-questions-q11-q20.md

int search(List<int> nums, int target) {
  var lo = 0, hi = nums.length - 1;
  while (lo <= hi) {
    final mid = (lo + hi) >> 1;
    if (nums[mid] == target) return mid;
    if (nums[mid] < target) lo = mid + 1; else hi = mid - 1;
  }
  return -1;
}
