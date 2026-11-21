// P1: Single number
// Source: solutions/ch27/README.md

function singleNumber(nums: number[]): number {
  return nums.reduce((a, x) => a ^ x, 0);
}

export {};
