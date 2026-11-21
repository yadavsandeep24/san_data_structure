// Q18. Binary Search
// Source: book/part-viii/29-interview-questions-q11-q20.md

function search(nums: number[], target: number): number {
  let lo = 0, hi = nums.length - 1;
  while (lo <= hi) {
    const mid = (lo + hi) >> 1;
    if (nums[mid] === target) return mid;
    if (nums[mid] < target) lo = mid + 1; else hi = mid - 1;
  }
  return -1;
}

export {};
