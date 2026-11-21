// P3: Car pooling (capacity check)
// Source: solutions/ch15/README.md

function carPooling(trips: [number, number, number][], capacity: number): boolean {
  const diff = new Array<number>(1001).fill(0);
  for (const [p, from, to] of trips) {
    diff[from] += p;
    diff[to] -= p;
  }
  let onBoard = 0;
  for (const d of diff) {
    onBoard += d;
    if (onBoard > capacity) return false;
  }
  return true;
}

export {};
