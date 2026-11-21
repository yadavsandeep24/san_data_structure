// Q14. Find Median from Data Stream
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

class MedianFinder {
  private low: number[] = []; // max-heap via negate compare
  private high: number[] = []; // min-heap

  private pushMax(h: number[], x: number) {
    h.push(x);
    h.sort((a, b) => b - a);
  }
  private pushMin(h: number[], x: number) {
    h.push(x);
    h.sort((a, b) => a - b);
  }
  private popMax(h: number[]): number {
    return h.shift()!;
  }
  private popMin(h: number[]): number {
    return h.shift()!;
  }

  addNum(num: number): void {
    this.pushMax(this.low, num);
    this.pushMin(this.high, this.popMax(this.low));
    if (this.high.length > this.low.length) this.pushMax(this.low, this.popMin(this.high));
  }

  findMedian(): number {
    if (this.low.length > this.high.length) return this.low[0];
    return (this.low[0] + this.high[0]) / 2;
  }
}

export {};
