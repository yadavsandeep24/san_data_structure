// Q8. Merge Intervals and Insert Interval Combo
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md
import 'dart:math';

List<List<int>> merge(List<List<int>> intervals) {
  if (intervals.isEmpty) return [];
  intervals.sort((a, b) => a[0].compareTo(b[0]));
  final out = [
    [intervals[0][0], intervals[0][1]]
  ];
  for (var i = 1; i < intervals.length; i++) {
    final last = out.last;
    final cur = intervals[i];
    if (cur[0] <= last[1]) {
      last[1] = max(last[1], cur[1]);
    } else {
      out.add([cur[0], cur[1]]);
    }
  }
  return out;
}

List<List<int>> insert(List<List<int>> intervals, List<int> newInterval) {
  final out = <List<int>>[];
  var i = 0;
  final n = intervals.length;
  var ns = newInterval[0], ne = newInterval[1];
  while (i < n && intervals[i][1] < ns) {
    out.add(intervals[i++]);
  }
  while (i < n && intervals[i][0] <= ne) {
    ns = min(ns, intervals[i][0]);
    ne = max(ne, intervals[i][1]);
    i++;
  }
  out.add([ns, ne]);
  while (i < n) {
    out.add(intervals[i++]);
  }
  return out;
}
