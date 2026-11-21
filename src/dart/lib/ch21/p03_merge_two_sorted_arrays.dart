// P3: Merge two sorted arrays
// Source: solutions/ch21/README.md

List<int> mergeSorted(List<int> a, List<int> b) {
  final out = <int>[];
  var i = 0, j = 0;
  while (i < a.length && j < b.length) {
    if (a[i] <= b[j]) {
      out.add(a[i++]);
    } else {
      out.add(b[j++]);
    }
  }
  while (i < a.length) {
    out.add(a[i++]);
  }
  while (j < b.length) {
    out.add(b[j++]);
  }
  return out;
}
