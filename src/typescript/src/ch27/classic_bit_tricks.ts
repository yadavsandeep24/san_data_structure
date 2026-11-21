// Classic bit tricks
// Source: book/part-vii/27-bits-matrix.md

function singleNumber(nums: number[]): number {
  return nums.reduce((a, x) => a ^ x, 0);
}

function isPowerOfTwo(n: number): boolean {
  return n > 0 && (n & (n - 1)) === 0; // `&` works on int32: valid for n ≤ 2^31
}

function hammingWeight(n: number): number {
  let c = 0;
  n = n >>> 0; // treat as uint32 if needed
  while (n) {
    n &= n - 1;
    c++;
  }
  return c;
}

export {};
