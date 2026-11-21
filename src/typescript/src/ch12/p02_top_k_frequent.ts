// P2: Top K frequent
// Source: solutions/ch12/README.md

function topKFrequent(nums: number[], k: number): number[] {
  const freq = new Map<number, number>();
  for (const x of nums) freq.set(x, (freq.get(x) ?? 0) + 1);
  const h: [number, number][] = []; // [freq, value]
  const siftUp = (i: number) => {
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (h[i][0] >= h[p][0]) break;
      [h[i], h[p]] = [h[p], h[i]];
      i = p;
    }
  };
  const siftDown = (i: number) => {
    for (;;) {
      let best = i;
      const l = i * 2 + 1, r = l + 1;
      if (l < h.length && h[l][0] < h[best][0]) best = l;
      if (r < h.length && h[r][0] < h[best][0]) best = r;
      if (best === i) break;
      [h[i], h[best]] = [h[best], h[i]];
      i = best;
    }
  };
  for (const [v, f] of freq) {
    h.push([f, v]);
    siftUp(h.length - 1);
    if (h.length > k) {
      h[0] = h.pop()!;
      if (h.length) siftDown(0);
    }
  }
  return h.map((e) => e[1]);
}

export {};
