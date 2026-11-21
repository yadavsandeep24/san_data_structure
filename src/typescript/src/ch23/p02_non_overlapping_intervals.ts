// P2: Non-overlapping intervals
// Source: solutions/ch23/README.md

function eraseOverlapIntervals(intervals: number[][]): number {
  if (!intervals.length) return 0;
  intervals.sort((a, b) => a[1] - b[1]);
  let keptEnd = intervals[0][1];
  let removals = 0;
  for (let i = 1; i < intervals.length; i++) {
    if (intervals[i][0] >= keptEnd) keptEnd = intervals[i][1];
    else removals++;
  }
  return removals;
}

export {};
