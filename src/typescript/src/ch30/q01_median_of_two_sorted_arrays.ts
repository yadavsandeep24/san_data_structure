// Q1. Median of Two Sorted Arrays (Fee Tier Cut)
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

function findMedianSortedArrays(a: number[], b: number[]): number {
  if (a.length > b.length) return findMedianSortedArrays(b, a);
  const m = a.length, n = b.length;
  let lo = 0, hi = m;
  const half = (m + n + 1) >> 1;
  const NEG = Number.NEGATIVE_INFINITY, POS = Number.POSITIVE_INFINITY;
  while (lo <= hi) {
    const i = (lo + hi) >> 1;
    const j = half - i;
    const aL = i === 0 ? NEG : a[i - 1];
    const aR = i === m ? POS : a[i];
    const bL = j === 0 ? NEG : b[j - 1];
    const bR = j === n ? POS : b[j];
    if (aL <= bR && bL <= aR) {
      return (m + n) % 2 === 0
        ? (Math.max(aL, bL) + Math.min(aR, bR)) / 2
        : Math.max(aL, bL);
    }
    if (aL > bR) hi = i - 1;
    else lo = i + 1;
  }
  throw new Error("unreachable");
}

export {};
