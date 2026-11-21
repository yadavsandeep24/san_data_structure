// Problem 1 — Remove duplicates, preserve order
// Source: solutions/ch03/README.md

function removeDuplicatesPreserveOrder(ids: string[]): string[] {
  const seen = new Set<string>();                // O(u) space
  const out: string[] = [];
  for (const id of ids) {                        // Θ(n)
    if (!seen.has(id)) {                         // O(1) average
      seen.add(id);
      out.push(id);                              // O(1) amortized
    }
  }
  return out;
}

// removeDuplicatesPreserveOrder(["a", "b", "a", "c", "b"]) === ["a", "b", "c"]

export {};
