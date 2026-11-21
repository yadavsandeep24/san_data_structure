// P1: Kth largest element
// Source: solutions/ch12/README.md

class MinHeap {
  private a: number[] = [];
  get size() { return this.a.length; }
  peek(): number { return this.a[0]; }
  push(x: number) {
    this.a.push(x);
    this.siftUp(this.a.length - 1);
  }
  pop(): number {
    const top = this.a[0];
    const last = this.a.pop()!;
    if (this.a.length) {
      this.a[0] = last;
      this.siftDown(0);
    }
    return top;
  }
  private siftUp(i: number) {
    const a = this.a;
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (a[i] >= a[p]) break;
      [a[i], a[p]] = [a[p], a[i]];
      i = p;
    }
  }
  private siftDown(i: number) {
    const a = this.a;
    for (;;) {
      let best = i;
      const l = i * 2 + 1, r = l + 1;
      if (l < a.length && a[l] < a[best]) best = l;
      if (r < a.length && a[r] < a[best]) best = r;
      if (best === i) break;
      [a[i], a[best]] = [a[best], a[i]];
      i = best;
    }
  }
}

function findKthLargest(nums: number[], k: number): number {
  const h = new MinHeap();
  for (const x of nums) {
    h.push(x);
    if (h.size > k) h.pop();
  }
  return h.peek();
}

export {};
