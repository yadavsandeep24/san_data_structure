// Q27. Meeting Rooms or Min Platforms (Heap)
// Source: book/part-viii/29-interview-questions-q21-q30.md

function minMeetingRooms(intervals: number[][]): number {
  if (!intervals.length) return 0;
  const sorted = [...intervals].sort((a, b) => a[0] - b[0]);
  const ends: number[] = []; // binary min-heap of end times
  const swap = (a: number, b: number) => { [ends[a], ends[b]] = [ends[b], ends[a]]; };
  function push(x: number): void {
    ends.push(x);
    let i = ends.length - 1;
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (ends[p] <= ends[i]) break;
      swap(p, i); i = p;
    }
  }
  function popMin(): void {
    const last = ends.pop()!;
    if (!ends.length) return;
    ends[0] = last;
    let i = 0;
    while (true) {
      let s = i;
      const l = 2 * i + 1, r = l + 1;
      if (l < ends.length && ends[l] < ends[s]) s = l;
      if (r < ends.length && ends[r] < ends[s]) s = r;
      if (s === i) break;
      swap(i, s); i = s;
    }
  }
  push(sorted[0][1]);
  for (let i = 1; i < sorted.length; i++) {
    if (sorted[i][0] >= ends[0]) popMin();
    push(sorted[i][1]);
  }
  return ends.length;
}

export {};
