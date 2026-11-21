// Q11. Longest Substring with At Most K Distinct Characters
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

function lengthOfLongestSubstringKDistinct(s: string, k: number): number {
  if (k === 0) return 0;
  const freq = new Map<string, number>();
  let lo = 0, best = 0;
  for (let hi = 0; hi < s.length; hi++) {
    freq.set(s[hi], (freq.get(s[hi]) ?? 0) + 1);
    while (freq.size > k) {
      const c = s[lo++];
      freq.set(c, freq.get(c)! - 1);
      if (freq.get(c) === 0) freq.delete(c);
    }
    best = Math.max(best, hi - lo + 1);
  }
  return best;
}

export {};
