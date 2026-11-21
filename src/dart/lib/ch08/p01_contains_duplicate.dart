// P1: Contains duplicate
// Source: solutions/ch08/README.md

bool containsDuplicate(List<int> nums) {
  final seen = <int>{};
  for (final x in nums) {
    if (!seen.add(x)) return true;
  }
  return false;
}
