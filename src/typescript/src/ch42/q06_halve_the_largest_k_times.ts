// Q6. Halve the Largest k Times (Compress the Biggest Attachments)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

/** Array-backed max-heap of numbers. */
class MaxHeap {
  private a: number[] = [];
  get size(): number { return this.a.length; }
  push(x: number): void {
    const a = this.a;
    a.push(x);
    let i = a.length - 1;
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (a[p] >= a[i]) break;
      [a[p], a[i]] = [a[i], a[p]];
      i = p;
    }
  }
  pop(): number {
    const a = this.a;
    const top = a[0];
    const last = a.pop()!;
    if (a.length > 0) {
      a[0] = last;
      let i = 0;
      for (;;) {
        const l = 2 * i + 1, r = l + 1;
        let m = i;
        if (l < a.length && a[l] > a[m]) m = l;
        if (r < a.length && a[r] > a[m]) m = r;
        if (m === i) break;
        [a[m], a[i]] = [a[i], a[m]];
        i = m;
      }
    }
    return top;
  }
}

function minSumAfterHalving(nums: number[], k: number): number {
  const heap = new MaxHeap();
  let sum = 0;
  for (const x of nums) { heap.push(x); sum += x; }
  for (let r = 0; r < k && heap.size > 0; r++) {
    const top = heap.pop();
    const half = Math.ceil(top / 2);
    sum -= top - half;
    heap.push(half);
  }
  return sum;
}

export {};
