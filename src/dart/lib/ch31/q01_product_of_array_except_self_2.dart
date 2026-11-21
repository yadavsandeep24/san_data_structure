// Q1 — Product of array except self (Swift / Dart)
// Source: solutions/ch31/README.md

List<int> productExceptSelf(List<int> nums) {
  final out = List<int>.filled(nums.length, 1);
  var prefix = 1;
  for (var i = 0; i < nums.length; i++) {
    out[i] = prefix;
    prefix *= nums[i];
  }
  var suffix = 1;
  for (var i = nums.length - 1; i >= 0; i--) {
    out[i] *= suffix;
    suffix *= nums[i];
  }
  return out;
}
