// P1: Membership under scroll
// Source: solutions/ch01/README.md

function countSelectedVisible(visibleIds: string[], selectedIds: string[]): number {
  const selected = new Set(selectedIds);
  let count = 0;
  for (const id of visibleIds) if (selected.has(id)) count++;
  return count;
}

export {};
