// Problem 2 — Rotate array right by k
// Source: solutions/ch03/README.md

function rotateRightInPlace(a: number[], kRaw: number): void {
  const n = a.length;
  if (n === 0) return;
  let k = kRaw % n;
  if (k < 0) k += n;
  if (k === 0) return;

  const reverse = (from: number, to: number) => {
    let i = from;
    let j = to - 1;
    while (i < j) {
      const tmp = a[i];
      a[i] = a[j];
      a[j] = tmp;
      i++;
      j--;
    }
  };

  reverse(0, n);                                 // Θ(n)
  reverse(0, k);                                 // Θ(k)
  reverse(k, n);                                 // Θ(n - k)
}

// const a = [1, 2, 3, 4, 5]; rotateRightInPlace(a, 2); // [4, 5, 1, 2, 3]

function rotateRightCopy(a: readonly number[], kRaw: number): number[] {
  const n = a.length;
  if (n === 0) return [];
  let k = kRaw % n;
  if (k < 0) k += n;
  const out = new Array<number>(n);
  for (let i = 0; i < n; i++) {
    out[(i + k) % n] = a[i];                     // Θ(n)
  }
  return out;
}

export {};
