// Worked example 2: bookings per hour with a difference array
// Source: book/part-iv/15-prefix-sums.md

function bookingsPerHour(hours: number, bookings: [number, number][]): number[] {
  const diff = new Array<number>(hours + 1).fill(0);
  for (const [start, end] of bookings) {
    diff[start] += 1;
    diff[end + 1] -= 1;
  }
  const out = new Array<number>(hours).fill(0);
  let running = 0;
  for (let h = 0; h < hours; h++) {
    running += diff[h];
    out[h] = running;
  }
  return out;
}

export {};
