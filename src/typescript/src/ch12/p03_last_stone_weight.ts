// P3: Last stone weight
// Source: solutions/ch12/README.md

class MaxHeap {
  private a: number[] = [];
  get size() { return this.a.length; }
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
      if (a[i] <= a[p]) break;
      [a[i], a[p]] = [a[p], a[i]];
      i = p;
    }
  }
  private siftDown(i: number) {
    const a = this.a;
    for (;;) {
      let best = i;
      const l = i * 2 + 1, r = l + 1;
      if (l < a.length && a[l] > a[best]) best = l;
      if (r < a.length && a[r] > a[best]) best = r;
      if (best === i) break;
      [a[i], a[best]] = [a[best], a[i]];
      i = best;
    }
  }
}

function lastStoneWeight(stones: number[]): number {
  const h = new MaxHeap();
  for (const s of stones) h.push(s);
  while (h.size > 1) {
    const x = h.pop();
    const y = h.pop();
    if (x !== y) h.push(x - y);
  }
  return h.size ? h.pop() : 0;
}

export {};
