// Q10 — First missing positive (Swift / Dart)
// Source: solutions/ch31/README.md

int firstMissingPositive(List<int> input) {
  final nums = List<int>.of(input);
  final n = nums.length;
  for (var i = 0; i < n; i++) {
    while (nums[i] >= 1 && nums[i] <= n && nums[nums[i] - 1] != nums[i]) {
      final j = nums[i] - 1;
      final tmp = nums[j];
      nums[j] = nums[i];
      nums[i] = tmp;
    }
  }
  for (var i = 0; i < n; i++) {
    if (nums[i] != i + 1) return i + 1;
  }
  return n + 1;
}
