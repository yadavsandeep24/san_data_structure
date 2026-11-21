// P2: Non-overlapping intervals
// Source: solutions/ch23/README.md

int eraseOverlapIntervals(List<List<int>> intervals) {
  if (intervals.isEmpty) return 0;
  intervals.sort((a, b) => a[1].compareTo(b[1]));
  var keptEnd = intervals[0][1];
  var removals = 0;
  for (var i = 1; i < intervals.length; i++) {
    if (intervals[i][0] >= keptEnd) {
      keptEnd = intervals[i][1];
    } else {
      removals++;
    }
  }
  return removals;
}
