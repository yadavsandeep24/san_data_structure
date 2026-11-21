// P1: Single number
// Source: solutions/ch27/README.md

int singleNumber(List<int> nums) {
  var x = 0;
  for (final n in nums) {
    x ^= n;
  }
  return x;
}
