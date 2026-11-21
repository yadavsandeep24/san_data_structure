// P2: Remove covered intervals
// Source: solutions/ch17/README.md

int removeCoveredIntervals(List<List<int>> intervals) {
  final sorted = [...intervals]
    ..sort((a, b) => a[0] != b[0] ? a[0].compareTo(b[0]) : b[1].compareTo(a[1]));
  var maxEnd = -1 << 62;
  var kept = 0;
  for (final iv in sorted) {
    if (iv[1] > maxEnd) {
      kept++;
      maxEnd = iv[1];
    }
  }
  return kept;
}
