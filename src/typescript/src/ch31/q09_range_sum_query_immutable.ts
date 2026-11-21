// Q9. Range Sum Query: Immutable (Statement Range Totals)
// Source: book/part-viii/31-arrays-hashing-matrix.md

class NumArray {
  private prefix: number[];

  constructor(nums: number[]) {
    this.prefix = new Array<number>(nums.length + 1).fill(0);
    for (let i = 0; i < nums.length; i++) this.prefix[i + 1] = this.prefix[i] + nums[i];
  }

  sumRange(left: number, right: number): number {
    return this.prefix[right + 1] - this.prefix[left];
  }
}

export {};
