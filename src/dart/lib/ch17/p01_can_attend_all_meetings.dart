// P1: Can attend all meetings
// Source: solutions/ch17/README.md

bool canAttendAll(List<List<int>> meetings) {
  final sorted = [...meetings]..sort((a, b) => a[0].compareTo(b[0]));
  for (var i = 1; i < sorted.length; i++) {
    if (sorted[i][0] < sorted[i - 1][1]) return false;
  }
  return true;
}
