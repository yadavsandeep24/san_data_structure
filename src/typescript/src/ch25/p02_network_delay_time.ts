// P2: Network delay time
// Source: solutions/ch25/README.md

class MinHeapPair {
  private a: [number, number][] = [];
  get size() { return this.a.length; }
  push(d: number, u: number) {
    this.a.push([d, u]);
    this.siftUp(this.a.length - 1);
  }
  pop(): [number, number] | undefined {
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
      if (a[i][0] >= a[p][0]) break;
      [a[i], a[p]] = [a[p], a[i]];
      i = p;
    }
  }
  private siftDown(i: number) {
    const a = this.a;
    for (;;) {
      let best = i;
      const l = i * 2 + 1, r = l + 1;
      if (l < a.length && a[l][0] < a[best][0]) best = l;
      if (r < a.length && a[r][0] < a[best][0]) best = r;
      if (best === i) break;
      [a[i], a[best]] = [a[best], a[i]];
      i = best;
    }
  }
}

function networkDelayTime(times: number[][], n: number, k: number): number {
  const g: [number, number][][] = Array.from({ length: n + 1 }, () => []);
  for (const [u, v, w] of times) g[u].push([v, w]);
  const dist = Array(n + 1).fill(Infinity);
  dist[k] = 0;
  const heap = new MinHeapPair();
  heap.push(0, k);
  while (heap.size) {
    const [d, u] = heap.pop()!;
    if (d > dist[u]) continue;
    for (const [v, w] of g[u]) {
      if (d + w < dist[v]) {
        dist[v] = d + w;
        heap.push(dist[v], v);
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
