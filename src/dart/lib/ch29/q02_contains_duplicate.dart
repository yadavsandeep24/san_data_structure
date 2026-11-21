// Q2. Contains Duplicate (Dedupe Guard)
// Source: book/part-viii/29-interview-questions-q01-q10.md

bool containsDuplicate(List<int> nums) {
  final s = <int>{};
  for (final x in nums) {
    if (!s.add(x)) return true;
  }
  return false;
}
