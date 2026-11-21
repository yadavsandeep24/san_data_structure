// Problem 1 — Remove duplicates, preserve order
// Source: solutions/ch03/README.md

List<String> removeDuplicatesPreserveOrder(List<String> ids) {
  final seen = <String>{};                       // O(u) space
  final out = <String>[];
  for (final id in ids) {                        // Θ(n)
    if (seen.add(id)) {                          // O(1) average; true if new
      out.add(id);                               // O(1) amortized
    }
  }
  return out;
}

// removeDuplicatesPreserveOrder(['a', 'b', 'a', 'c', 'b']) == ['a', 'b', 'c']
