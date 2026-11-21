// Q9. Highest JPEG Quality That Fits the Upload Limit (Binary Search on the Answer)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md

/** size(q) must not decrease as q rises. Largest q in [lo, hi] with size(q) <= limit, or null. */
function bestQuality(lo: number, hi: number, limit: number, size: (q: number) => number): number | null {
  let l = lo, h = hi;
  let best: number | null = null;
  while (l <= h) {
    const mid = l + ((h - l) >> 1);
    if (size(mid) <= limit) { best = mid; l = mid + 1; } else h = mid - 1;
  }
  return best;
}

export {};
