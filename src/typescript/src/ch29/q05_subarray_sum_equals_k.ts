// Q5. Subarray Sum Equals K
// Source: book/part-viii/29-interview-questions-q01-q10.md

function subarraySum(nums: number[], k: number): number {
  const freq = new Map<number, number>([[0, 1]]);
  let sum = 0, ans = 0;
  for (const x of nums) {
    sum += x;
    ans += freq.get(sum - k) ?? 0;
    freq.set(sum, (freq.get(sum) ?? 0) + 1);
  }
  return ans;
}

export {};
