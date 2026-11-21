// Worked example 1: O(1) spend between two days
// Source: book/part-iv/15-prefix-sums.md

class SpendRanges {
  final List<int> _prefix;
  SpendRanges(List<int> daily) : _prefix = List<int>.filled(daily.length + 1, 0) {
    for (var i = 0; i < daily.length; i++) {
      _prefix[i + 1] = _prefix[i] + daily[i];
    }
  }
  int total(int from, int to) => _prefix[to + 1] - _prefix[from];
}
