// Q6. Search in Rotated Sorted Array II (Duplicates Allowed)
// Source: book/part-viii/33-stacks-binary-search.md

bool searchRotatedWithDups(List<int> nums, int target) {
  var lo = 0, hi = nums.length - 1;
  while (lo <= hi) {
    final mid = lo + (hi - lo) ~/ 2;
    if (nums[mid] == target) return true;
    if (nums[lo] == nums[mid] && nums[mid] == nums[hi]) { // can't tell which half is sorted
      lo++;
      hi--;
    } else if (nums[lo] <= nums[mid]) {
      if (target >= nums[lo] && target < nums[mid]) { hi = mid - 1; } else { lo = mid + 1; }
    } else {
      if (target > nums[mid] && target <= nums[hi]) { lo = mid + 1; } else { hi = mid - 1; }
    }
  }
  return false;
}
