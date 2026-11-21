// Q2. K Closest Points to Origin (Nearest Stores on the Map)
// Source: book/part-viii/35-heaps-tries-greedy.md
import { Heap } from './q01_kth_largest_element_in_a_stream';

// uses Heap<T> from Q1
function kClosest(points: number[][], k: number): number[][] {
  const d = (p: number[]) => p[0] * p[0] + p[1] * p[1];
  const heap = new Heap<number[]>((a, b) => d(a) > d(b)); // max-heap by distance
  for (const p of points) {
    heap.push(p);
    if (heap.size > k) heap.pop(); // drop the farthest
  }
  const out: number[][] = [];
  while (heap.size > 0) out.push(heap.pop()!);
  return out;
}

export {};
