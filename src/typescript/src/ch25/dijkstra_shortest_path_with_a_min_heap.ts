// Dijkstra — shortest path with a min-heap
// Source: book/part-vii/25-graphs-advanced.md
import { MinHeap } from '../ch12/language_realities';   // generic heap from Chapter 12

function networkDelayTime(times: number[][], n: number, k: number): number {
  const g: [number, number][][] = Array.from({ length: n + 1 }, () => []);
  for (const [u, v, w] of times) g[u].push([v, w]);
  const dist = Array(n + 1).fill(Infinity);
  dist[k] = 0;
  const heap = new MinHeap<[number, number]>((a, b) => a[0] - b[0]);
  heap.push([0, k]);
  while (heap.size) {
    const [d, u] = heap.pop()!;
    if (d > dist[u]) continue;
    for (const [v, w] of g[u]) {
      if (d + w < dist[v]) {
        dist[v] = d + w;
        heap.push([dist[v], v]);
      }
    }
  }
  let ans = 0;
  for (let i = 1; i <= n; i++) {
    if (dist[i] === Infinity) return -1;
    ans = Math.max(ans, dist[i]);
  }
  return ans;
}

export {};
