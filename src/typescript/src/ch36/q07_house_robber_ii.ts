// Q7. House Robber II (Circular Carousel Ad Slots)
// Source: book/part-viii/36-graphs-dynamic-programming.md

function rob(nums: number[]): number {
  if (nums.length === 1) return nums[0];
  const robLine = (from: number, to: number): number => {
    let prev = 0, best = 0; // best up to i-2, best up to i-1
    for (let i = from; i <= to; i++) {
      const take = prev + nums[i];
      prev = best;
      best = Math.max(best, take);
    }
    return best;
  };
  return Math.max(robLine(0, nums.length - 2), robLine(1, nums.length - 1));
}

export {};
