// Language realities
// Source: book/part-iii/12-heaps-priority-queues.md

export class MinHeap<T = number> {
  private a: T[] = [];
  constructor(private cmp: (a: T, b: T) => number = (a, b) => (a as number) - (b as number)) {}
  get size() { return this.a.length; }
  peek(): T | undefined { return this.a[0]; }
  push(x: T) {
    this.a.push(x);
    this.siftUp(this.a.length - 1);
  }
  pop(): T | undefined {
    if (!this.a.length) return undefined;
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
      if (this.cmp(a[i], a[p]) >= 0) break;
      [a[i], a[p]] = [a[p], a[i]];
      i = p;
    }
  }
  private siftDown(i: number) {
    const a = this.a;
    for (;;) {
      let best = i;
      const l = i * 2 + 1, r = l + 1;
      if (l < a.length && this.cmp(a[l], a[best]) < 0) best = l;
      if (r < a.length && this.cmp(a[r], a[best]) < 0) best = r;
      if (best === i) break;
      [a[i], a[best]] = [a[best], a[i]];
      i = best;
    }
  }
}

export {};
