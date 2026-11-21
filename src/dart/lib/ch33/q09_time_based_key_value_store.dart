// Q9. Time Based Key-Value Store (Versioned Config Cache)
// Source: book/part-viii/33-stacks-binary-search.md

class TimeMap {
  final _store = <String, List<(int, String)>>{};

  // Timestamps for a key arrive in increasing order, so each list stays sorted.
  void set(String key, String value, int timestamp) {
    _store.putIfAbsent(key, () => []).add((timestamp, value));
  }

  String get(String key, int timestamp) {
    final list = _store[key];
    if (list == null) return '';
    var lo = 0, hi = list.length - 1;
    var ans = '';
    while (lo <= hi) { // last entry with time <= timestamp
      final mid = lo + (hi - lo) ~/ 2;
      if (list[mid].$1 <= timestamp) {
        ans = list[mid].$2;
        lo = mid + 1;
      } else {
        hi = mid - 1;
      }
    }
    return ans;
  }
}
