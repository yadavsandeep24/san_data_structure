// P1: Can attend all meetings
// Source: solutions/ch17/README.md

function canAttendAll(meetings: [number, number][]): boolean {
  const sorted = [...meetings].sort((a, b) => a[0] - b[0]);
  for (let i = 1; i < sorted.length; i++) {
    if (sorted[i][0] < sorted[i - 1][1]) return false;
  }
  return true;
}

export {};
