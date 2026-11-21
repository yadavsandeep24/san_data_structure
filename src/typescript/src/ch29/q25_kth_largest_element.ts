// Q25. Kth Largest Element
// Source: book/part-viii/29-interview-questions-q21-q30.md

// Min-heap via array for interview clarity
function findKthLargest(nums: number[], k: number): number {
  const heap: number[] = [];
  const swap = (a: number, b: number) => { [heap[a], heap[b]] = [heap[b], heap[a]]; };
  function siftUp(i: number): void {
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (heap[p] <= heap[i]) break;
      swap(p, i); i = p;
    }
  }
  function siftDown(i: number): void {
    while (true) {
      let s = i;
      const l = 2 * i + 1, r = l + 1;
      if (l < heap.length && heap[l] < heap[s]) s = l;
      if (r < heap.length && heap[r] < heap[s]) s = r;
      if (s === i) break;
      swap(i, s); i = s;
    }
  }
  for (const x of nums) {
    if (heap.length < k) { heap.push(x); siftUp(heap.length - 1); }
    else if (x > heap[0]) { heap[0] = x; siftDown(0); }
  }
  return heap[0];
}

export {};
