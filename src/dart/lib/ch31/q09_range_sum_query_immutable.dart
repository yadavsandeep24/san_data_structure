// Q9. Range Sum Query: Immutable (Statement Range Totals)
// Source: book/part-viii/31-arrays-hashing-matrix.md

class NumArray {
  final List<int> _prefix;

  NumArray(List<int> nums) : _prefix = List<int>.filled(nums.length + 1, 0) {
    for (var i = 0; i < nums.length; i++) {
      _prefix[i + 1] = _prefix[i] + nums[i];
    }
  }

  int sumRange(int left, int right) => _prefix[right + 1] - _prefix[left];
}
