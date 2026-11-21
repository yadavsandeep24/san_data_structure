// Q27. Meeting Rooms or Min Platforms (Heap)
// Source: book/part-viii/29-interview-questions-q21-q30.md
import 'dart:math';

int minMeetingRooms(List<List<int>> intervals) {
  if (intervals.isEmpty) return 0;
  final sorted = [...intervals]..sort((a, b) => a[0].compareTo(b[0]));
  final ends = <int>[]; // binary min-heap of end times
  void push(int x) {
    ends.add(x);
    var i = ends.length - 1;
    while (i > 0) {
      final p = (i - 1) >> 1;
      if (ends[p] <= ends[i]) break;
      final t = ends[p]; ends[p] = ends[i]; ends[i] = t; i = p;
    }
  }
  void popMin() {
    final last = ends.removeLast();
    if (ends.isEmpty) return;
    ends[0] = last;
    var i = 0;
    while (true) {
      var s = i;
      final l = 2 * i + 1, r = l + 1;
      if (l < ends.length && ends[l] < ends[s]) s = l;
      if (r < ends.length && ends[r] < ends[s]) s = r;
      if (s == i) break;
      final t = ends[s]; ends[s] = ends[i]; ends[i] = t; i = s;
    }
  }
  push(sorted[0][1]);
  for (var i = 1; i < sorted.length; i++) {
    if (sorted[i][0] >= ends[0]) popMin();
    push(sorted[i][1]);
  }
  return ends.length;
}
