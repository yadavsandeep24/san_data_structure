// Worked example 1: merge busy blocks
// Source: book/part-iv/17-intervals-sweep-line.md

List<List<int>> mergeBusy(List<List<int>> blocks) {
  final sorted = [...blocks]..sort((a, b) => a[0].compareTo(b[0]));
  final out = <List<int>>[];
  for (final b in sorted) {
    if (out.isNotEmpty && b[0] <= out.last[1]) {
      if (b[1] > out.last[1]) out.last[1] = b[1];
    } else {
      out.add([b[0], b[1]]);
    }
  }
  return out;
}
