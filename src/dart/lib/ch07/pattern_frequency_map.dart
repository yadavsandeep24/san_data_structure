// Pattern: frequency map
// Source: book/part-iii/07-hash-tables.md

Map<String, int> freq(String s) {
  final m = <String, int>{};
  for (final c in s.split('')) m[c] = (m[c] ?? 0) + 1; // UTF-16 units
  return m;
}
