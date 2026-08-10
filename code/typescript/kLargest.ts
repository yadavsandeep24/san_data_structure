// Sample: k largest values via size-k min-heap (Chapter 18)
export function kLargest(nums: number[], k: number): number[] {
  const heap: number[] = [];
  const siftUp = (i: number) => {
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (heap[i] >= heap[p]) break;
      [heap[i], heap[p]] = [heap[p], heap[i]];
      i = p;
    }
  };
  const siftDown = (i: number) => {
    for (;;) {
      let best = i;
      const l = i * 2 + 1, r = l + 1;
      if (l < heap.length && heap[l] < heap[best]) best = l;
      if (r < heap.length && heap[r] < heap[best]) best = r;
      if (best === i) break;
      [heap[i], heap[best]] = [heap[best], heap[i]];
      i = best;
    }
  };
  for (const n of nums) {
    heap.push(n);
    siftUp(heap.length - 1);
    if (heap.length > k) {
      const last = heap.pop()!;
      if (heap.length) {
        heap[0] = last;
        siftDown(0);
      }
    }
  }
  return [...heap].sort((a, b) => b - a);
}
