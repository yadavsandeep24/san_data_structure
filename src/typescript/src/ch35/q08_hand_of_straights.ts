// Q8. Hand of Straights (Consecutive Ticket Batches)
// Source: book/part-viii/35-heaps-tries-greedy.md

function isNStraightHand(hand: number[], groupSize: number): boolean {
  if (hand.length % groupSize !== 0) return false;
  const count = new Map<number, number>();
  for (const h of hand) count.set(h, (count.get(h) ?? 0) + 1);
  const keys = [...count.keys()].sort((a, b) => a - b);
  for (const first of keys) {
    const need = count.get(first)!; // groups that must start here
    if (need === 0) continue;
    for (let v = first; v < first + groupSize; v++) {
      const have = count.get(v) ?? 0;
      if (have < need) return false;
      count.set(v, have - need);
    }
  }
  return true;
}

export {};
