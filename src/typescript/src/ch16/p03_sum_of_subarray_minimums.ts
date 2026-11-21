// P3: Sum of subarray minimums
// Source: solutions/ch16/README.md

function sumSubarrayMins(a: number[]): number {
  const MOD = 1_000_000_007;
  const stack: number[] = [];
  let total = 0;
  for (let i = 0; i <= a.length; i++) {
    const cur = i === a.length ? -Infinity : a[i];
    while (stack.length > 0 && a[stack[stack.length - 1]] >= cur) {
      const j = stack.pop()!;
      const k = stack.length > 0 ? stack[stack.length - 1] : -1;
      // a[j] ≤ 3·10^4 and (j-k)(i-j) ≤ 9·10^8 ⇒ product < 2^53, safe in a double
      total = (total + ((a[j] * (j - k) * (i - j)) % MOD)) % MOD;
    }
    stack.push(i);
  }
  return total;
}

export {};
