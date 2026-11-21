// P1: Move zeroes
// Source: solutions/ch13/README.md

function moveZeroes(a: number[]): void {
  let write = 0;
  for (let read = 0; read < a.length; read++) {
    if (a[read] !== 0) a[write++] = a[read];
  }
  while (write < a.length) a[write++] = 0;
}

export {};
