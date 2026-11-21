// Worked example 2: peak concurrent downloads (sweep line)
// Source: book/part-iv/17-intervals-sweep-line.md

function peakConcurrent(intervals: [number, number][]): number {
  const events: [number, number][] = [];
  for (const [s, e] of intervals) {
    events.push([s, 1], [e, -1]);
  }
  events.sort((a, b) => a[0] - b[0] || a[1] - b[1]);
  let active = 0;
  let peak = 0;
  for (const [, delta] of events) {
    active += delta;
    peak = Math.max(peak, active);
  }
  return peak;
}

export {};
