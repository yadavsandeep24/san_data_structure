// P1: Next greater element, circular
// Source: solutions/ch16/README.md

function nextGreaterCircular(a: number[]): number[] {
  const n = a.length;
  const ans = new Array<number>(n).fill(-1);
  const stack: number[] = [];
  for (let i = 0; i < 2 * n; i++) {
    const x = a[i % n];
    while (stack.length > 0 && a[stack[stack.length - 1]] < x) ans[stack.pop()!] = x;
    if (i < n) stack.push(i);
  }
  return ans;
}

export {};
