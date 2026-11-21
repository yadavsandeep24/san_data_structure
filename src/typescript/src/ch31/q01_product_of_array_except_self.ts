// Q1. Product of Array Except Self (Basket Price Multipliers)
// Source: book/part-viii/31-arrays-hashing-matrix.md

function productExceptSelf(nums: number[]): number[] {
  const out = new Array<number>(nums.length).fill(1);
  let prefix = 1;
  for (let i = 0; i < nums.length; i++) {
    out[i] = prefix;
    prefix *= nums[i];
  }
  let suffix = 1;
  for (let i = nums.length - 1; i >= 0; i--) {
    out[i] *= suffix;
    suffix *= nums[i];
  }
  return out;
}

export {};
