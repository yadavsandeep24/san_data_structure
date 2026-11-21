// P2: Squares of a sorted array
// Source: solutions/ch13/README.md

function sortedSquares(a: number[]): number[] {
  const out = new Array<number>(a.length).fill(0);
  let lo = 0;
  let hi = a.length - 1;
  for (let pos = a.length - 1; pos >= 0; pos--) {
    const l = a[lo] * a[lo];
    const h = a[hi] * a[hi];
    if (l > h) {
      out[pos] = l;
      lo++;
    } else {
      out[pos] = h;
      hi--;
    }
  }
  return out;
}

export {};
