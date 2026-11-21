// Q4. Top K Frequent Elements
// Source: book/part-viii/29-interview-questions-q01-q10.md

function topKFrequent(nums: number[], k: number): number[] {
  const freq = new Map<number, number>();
  for (const x of nums) freq.set(x, (freq.get(x) ?? 0) + 1);
  const buckets: number[][] = Array.from({ length: nums.length + 1 }, () => []);
  for (const [v, f] of freq) buckets[f].push(v);
  const out: number[] = [];
  for (let f = buckets.length - 1; f >= 0; f--) {
    for (const v of buckets[f]) {
      out.push(v);
      if (out.length === k) return out;
    }
  }
  return out;
}

export {};
