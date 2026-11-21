// Worked example: nested loop vs HashSet membership
// Source: book/part-i/01-why-data-structures-matter.md

// BAD

bool isSelectedSlow(String id, List<String> selected) {
  for (final s in selected) {      // O(m)
    if (s == id) return true;
  }
  return false;
}

// GOOD
Set<String> buildSelectedSet(List<String> selected) =>
    selected.toSet();              // O(m)

bool isSelectedFast(String id, Set<String> selectedSet) =>
    selectedSet.contains(id);      // O(1) average
