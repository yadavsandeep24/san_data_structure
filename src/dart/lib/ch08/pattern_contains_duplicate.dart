// Pattern: contains duplicate
// Source: book/part-iii/08-sets.md

bool containsDuplicate(List<int> nums) {
  final seen = <int>{};
  for (final x in nums) {
    if (!seen.add(x)) return true; // add returns false if already present
  }
  return false;
}
