// Binary search on the answer
// Source: book/part-vi/21-searching-sorting.md

int minDailyQuota(List<int> files, int days) {
  int daysNeeded(int quota) {
    var used = 0, count = 1;
    for (final f in files) {
      if (used + f > quota) {
        count++;
        used = 0;
      }
      used += f;
    }
    return count;
  }

  var lo = files.reduce((a, b) => a > b ? a : b);
  var hi = files.fold<int>(0, (s, x) => s + x);
  while (lo < hi) {
    final mid = lo + (hi - lo) ~/ 2;
    if (daysNeeded(mid) <= days) {
      hi = mid;
    } else {
      lo = mid + 1;
    }
  }
  return lo;
}
