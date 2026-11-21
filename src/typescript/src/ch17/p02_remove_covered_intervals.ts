// P2: Remove covered intervals
// Source: solutions/ch17/README.md

function removeCoveredIntervals(intervals: [number, number][]): number {
  const sorted = [...intervals].sort((a, b) => a[0] - b[0] || b[1] - a[1]);
  let maxEnd = -Infinity;
  let kept = 0;
  for (const [, end] of sorted) {
    if (end > maxEnd) {
      kept++;
      maxEnd = end;
    }
  }
  return kept;
}

export {};
