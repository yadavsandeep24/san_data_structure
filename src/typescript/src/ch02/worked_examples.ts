// Worked examples (four languages)
// Source: book/part-i/02-big-o-notation.md

function frequencies(ids: string[]): Map<string, number> {
  const counts = new Map<string, number>();       // O(u) space
  for (const id of ids) {                         // Θ(n)
    counts.set(id, (counts.get(id) ?? 0) + 1);    // O(1) average
  }
  return counts;
}

export {};
