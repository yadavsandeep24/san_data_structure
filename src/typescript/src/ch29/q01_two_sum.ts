// Q1. Two Sum (Cart SKU Pair)
// Source: book/part-viii/29-interview-questions-q01-q10.md

function twoSum(nums: number[], target: number): number[] {
  const seen = new Map<number, number>();
  for (let i = 0; i < nums.length; i++) {
    const j = seen.get(target - nums[i]);
    if (j !== undefined) return [j, i];
    seen.set(nums[i], i);
  }
  return [];
}

export {};
