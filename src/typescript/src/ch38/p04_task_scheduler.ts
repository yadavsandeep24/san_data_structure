// P4. Task Scheduler (Priority Queue)
// Source: solutions/ch38/README.md

export type T = { id: string; priority: number; seq: number; run: () => void };
class TaskScheduler {
  private heap: T[] = [];
  private cancelled = new Set<string>();
  private seq = 0;
  private before(a: T, b: T) {
    return a.priority !== b.priority ? a.priority > b.priority : a.seq < b.seq;
  }
  schedule(id: string, priority: number, run: () => void) {
    this.heap.push({ id, priority, seq: this.seq++, run });
    this.siftUp(this.heap.length - 1);
  }
  cancel(id: string) { this.cancelled.add(id); }
  runNext(): boolean {
    while (this.heap.length) {
      const t = this.pop();
      if (this.cancelled.delete(t.id)) continue;
      t.run(); return true;
    }
    return false;
  }
  private siftUp(i: number) {
    const a = this.heap;
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (!this.before(a[i], a[p])) break;
      [a[i], a[p]] = [a[p], a[i]];
      i = p;
    }
  }
  private siftDown(i: number) {
    const a = this.heap;
    for (;;) {
      let best = i;
      const l = i * 2 + 1, r = l + 1;
      if (l < a.length && this.before(a[l], a[best])) best = l;
      if (r < a.length && this.before(a[r], a[best])) best = r;
      if (best === i) break;
      [a[i], a[best]] = [a[best], a[i]];
      i = best;
    }
  }
  private pop(): T {
    const top = this.heap[0];
    const last = this.heap.pop()!;
    if (this.heap.length) {
      this.heap[0] = last;
      this.siftDown(0);
    }
    return top;
  }
}

export {};
