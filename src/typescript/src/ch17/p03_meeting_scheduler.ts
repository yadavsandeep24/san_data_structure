// P3: Meeting scheduler (two calendars)
// Source: solutions/ch17/README.md

function meetingScheduler(
  slotsA: [number, number][],
  slotsB: [number, number][],
  duration: number,
): [number, number] | null {
  const a = [...slotsA].sort((x, y) => x[0] - y[0]);
  const b = [...slotsB].sort((x, y) => x[0] - y[0]);
  let i = 0;
  let j = 0;
  while (i < a.length && j < b.length) {
    const start = Math.max(a[i][0], b[j][0]);
    const end = Math.min(a[i][1], b[j][1]);
    if (end - start >= duration) return [start, start + duration];
    if (a[i][1] < b[j][1]) i++;
    else j++;
  }
  return null;
}

export {};
