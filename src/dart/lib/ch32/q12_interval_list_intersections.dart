// Q12. Interval List Intersections (Shared Free Slots)
// Source: book/part-viii/32-two-pointers-windows-intervals.md
import 'dart:math';

List<List<int>> intervalIntersection(List<List<int>> a, List<List<int>> b) {
  final out = <List<int>>[];
  var i = 0, j = 0;
  while (i < a.length && j < b.length) {
    final lo = max(a[i][0], b[j][0]);
    final hi = min(a[i][1], b[j][1]);
    if (lo <= hi) out.add([lo, hi]);
    if (a[i][1] < b[j][1]) {
      i++;
    } else {
      j++;
    }
  }
  return out;
}
