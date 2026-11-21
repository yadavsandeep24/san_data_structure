// Worked example 1: dedupe a sorted array in place (read/write)
// Source: book/part-iv/13-two-pointers.md

int dedupeSortedInPlace(List<int> a) {
  if (a.isEmpty) return 0;
  var write = 1;
  for (var read = 1; read < a.length; read++) {
    if (a[read] != a[write - 1]) {
      a[write] = a[read];
      write++;
    }
  }
  return write;
}
