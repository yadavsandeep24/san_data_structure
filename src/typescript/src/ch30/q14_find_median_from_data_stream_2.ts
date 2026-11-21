// Q14: Find median from data stream (TypeScript two-heap or Swift or Dart)
// Source: solutions/ch30/README.md

class MedianFinderHeaps {
  private low: number[] = [];
  private high: number[] = [];

  private less(a: number, b: number) { return a < b; }

  private pushHeap(h: number[], x: number, isMax: boolean) {
    h.push(x);
    let i = h.length - 1;
    while (i > 0) {
      const p = (i - 1) >> 1;
      const ok = isMax ? h[i] <= h[p] : h[i] >= h[p];
      if (ok) break;
      [h[i], h[p]] = [h[p], h[i]];
      i = p;
    }
  }

  private popHeap(h: number[], isMax: boolean): number {
    const top = h[0];
    const last = h.pop()!;
    if (h.length) {
      h[0] = last;
      this.siftDown(h, 0, isMax);
    }
    return top;
  }

  private siftDown(h: number[], i: number, isMax: boolean) {
    for (;;) {
      let best = i;
      const l = i * 2 + 1, r = l + 1;
      const better = (a: number, b: number) => isMax ? a > b : a < b;
      if (l < h.length && better(h[l], h[best])) best = l;
      if (r < h.length && better(h[r], h[best])) best = r;
      if (best === i) break;
      [h[i], h[best]] = [h[best], h[i]];
      i = best;
    }
  }

  addNum(num: number): void {
    this.pushHeap(this.low, num, true);
    this.pushHeap(this.high, this.popHeap(this.low, true), false);
    if (this.high.length > this.low.length) {
      this.pushHeap(this.low, this.popHeap(this.high, false), true);
    }
  }

  findMedian(): number {
    if (this.low.length > this.high.length) return this.low[0];
    return (this.low[0] + this.high[0]) / 2;
  }
}

export {};
