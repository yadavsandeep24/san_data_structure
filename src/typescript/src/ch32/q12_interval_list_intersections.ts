// Q12. Interval List Intersections (Shared Free Slots)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

function intervalIntersection(a: number[][], b: number[][]): number[][] {
  const out: number[][] = [];
  let i = 0;
  let j = 0;
  while (i < a.length && j < b.length) {
    const lo = Math.max(a[i][0], b[j][0]);
    const hi = Math.min(a[i][1], b[j][1]);
    if (lo <= hi) out.push([lo, hi]);
    if (a[i][1] < b[j][1]) i++;
    else j++;
  }
  return out;
}

export {};
