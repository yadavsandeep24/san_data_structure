// Q11. Minimum Number of Arrows to Burst Balloons (Fewest Sync Ticks)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

int findMinArrowShots(List<List<int>> points) {
  if (points.isEmpty) return 0;
  final sorted = List<List<int>>.of(points)..sort((a, b) => a[1].compareTo(b[1]));
  var arrows = 1;
  var arrowX = sorted[0][1];
  for (final p in sorted) {
    if (p[0] > arrowX) {
      arrows++;
      arrowX = p[1];
    }
  }
  return arrows;
}
