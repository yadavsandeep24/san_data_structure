// P3: Meeting scheduler (two calendars)
// Source: solutions/ch17/README.md

List<int>? meetingScheduler(List<List<int>> slotsA, List<List<int>> slotsB, int duration) {
  final a = [...slotsA]..sort((x, y) => x[0].compareTo(y[0]));
  final b = [...slotsB]..sort((x, y) => x[0].compareTo(y[0]));
  var i = 0, j = 0;
  while (i < a.length && j < b.length) {
    final start = a[i][0] > b[j][0] ? a[i][0] : b[j][0];
    final end = a[i][1] < b[j][1] ? a[i][1] : b[j][1];
    if (end - start >= duration) return [start, start + duration];
    if (a[i][1] < b[j][1]) {
      i++;
    } else {
      j++;
    }
  }
  return null;
}
