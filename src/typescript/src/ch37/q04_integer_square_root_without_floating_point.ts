// Q4. Integer Square Root without Floating Point (Thumbnail Grid)
// Source: book/part-viii/37-math-and-number-drills.md

// BigInt so the input can be any 64-bit value, like Kotlin's Long.
function isqrt(x: bigint): bigint {
  if (x < 0n) throw new RangeError("negative");
  let lo = 0n;
  let hi = x < 3_037_000_499n ? x : 3_037_000_499n;
  while (lo < hi) {
    const mid = lo + (hi - lo + 1n) / 2n;           // round up so the loop always shrinks
    if (mid <= x / mid) lo = mid; else hi = mid - 1n;
  }
  return lo;
}

export {};
