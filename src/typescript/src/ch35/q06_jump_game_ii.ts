// Q6. Jump Game II (Fewest Deep-Link Hops)
// Source: book/part-viii/35-heaps-tries-greedy.md

function jump(nums: number[]): number {
  let jumps = 0, curEnd = 0, farthest = 0;
  for (let i = 0; i < nums.length - 1; i++) {
    farthest = Math.max(farthest, i + nums[i]);
    if (i === curEnd) {
      jumps++;
      curEnd = farthest;
    }
  }
  return jumps;
}

export {};
