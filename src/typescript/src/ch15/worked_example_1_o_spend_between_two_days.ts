// Worked example 1: O(1) spend between two days
// Source: book/part-iv/15-prefix-sums.md

class SpendRanges {
  private readonly prefix: number[];
  constructor(daily: number[]) {
    this.prefix = new Array<number>(daily.length + 1).fill(0);
    for (let i = 0; i < daily.length; i++) this.prefix[i + 1] = this.prefix[i] + daily[i];
  }
  total(from: number, to: number): number {
    return this.prefix[to + 1] - this.prefix[from];
  }
}

export {};
