// Q11. Minimum Number of Arrows to Burst Balloons (Fewest Sync Ticks)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

function findMinArrowShots(points: number[][]): number {
  if (points.length === 0) return 0;
  const sorted = [...points].sort((a, b) => (a[1] < b[1] ? -1 : a[1] > b[1] ? 1 : 0));
  let arrows = 1;
  let arrowX = sorted[0][1];
  for (const p of sorted) {
    if (p[0] > arrowX) {
      arrows++;
      arrowX = p[1];
    }
  }
  return arrows;
}

export {};
