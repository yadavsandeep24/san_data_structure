// Worked example 2: peak concurrent downloads (sweep line)
// Source: book/part-iv/17-intervals-sweep-line.md

int peakConcurrent(List<List<int>> intervals) {
  final events = <List<int>>[];
  for (final iv in intervals) {
    events.add([iv[0], 1]);
    events.add([iv[1], -1]);
  }
  events.sort((a, b) => a[0] != b[0] ? a[0].compareTo(b[0]) : a[1].compareTo(b[1]));
  var active = 0, peak = 0;
  for (final e in events) {
    active += e[1];
    if (active > peak) peak = active;
  }
  return peak;
}
