// Q8. Merge Intervals and Insert Interval Combo
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

function merge(intervals: number[][]): number[][] {
  if (!intervals.length) return [];
  intervals.sort((a, b) => a[0] - b[0]);
  const out: number[][] = [[intervals[0][0], intervals[0][1]]];
  for (let i = 1; i < intervals.length; i++) {
    const last = out[out.length - 1];
    const cur = intervals[i];
    if (cur[0] <= last[1]) last[1] = Math.max(last[1], cur[1]);
    else out.push([cur[0], cur[1]]);
  }
  return out;
}

function insert(intervals: number[][], newInterval: number[]): number[][] {
  const out: number[][] = [];
  let i = 0;
  const n = intervals.length;
  let [ns, ne] = newInterval;
  while (i < n && intervals[i][1] < ns) out.push(intervals[i++]);
  while (i < n && intervals[i][0] <= ne) {
    ns = Math.min(ns, intervals[i][0]);
    ne = Math.max(ne, intervals[i][1]);
    i++;
  }
  out.push([ns, ne]);
  while (i < n) out.push(intervals[i++]);
  return out;
}

export {};
