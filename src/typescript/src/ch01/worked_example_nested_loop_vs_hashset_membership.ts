// Worked example: nested loop vs HashSet membership
// Source: book/part-i/01-why-data-structures-matter.md

// BAD — avoid inside FlatList renderItem / onChangeText
function isSelectedSlow(id: string, selected: string[]): boolean {
  for (const s of selected) {      // O(m)
    if (s === id) return true;
  }
  return false;
}

// GOOD
function buildSelectedSet(selected: string[]): Set<string> {
  return new Set(selected);        // O(m)
}

function isSelectedFast(id: string, selectedSet: Set<string>): boolean {
  return selectedSet.has(id);      // O(1) average
}

export {};
