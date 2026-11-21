// P2: Intersection of two arrays
// Source: solutions/ch08/README.md

List<int> intersection(List<int> a, List<int> b) {
  final setA = a.toSet();
  final out = <int>{};
  for (final x in b) {
    if (setA.contains(x)) out.add(x);
  }
  return out.toList();
}
