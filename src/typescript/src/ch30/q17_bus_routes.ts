// Q17. Bus Routes (Hard BFS)
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

function numBusesToDestination(routes: number[][], source: number, target: number): number {
  if (source === target) return 0;
  const stopToBus = new Map<number, number[]>();
  routes.forEach((r, b) => r.forEach((s) => {
    if (!stopToBus.has(s)) stopToBus.set(s, []);
    stopToBus.get(s)!.push(b);
  }));
  const q: number[] = [source];
  const seenBus = new Set<number>();
  const seenStop = new Set<number>([source]);
  let buses = 0;
  while (q.length) {
    buses++;
    const size = q.length;
    for (let i = 0; i < size; i++) {
      const stop = q.shift()!;
      for (const b of stopToBus.get(stop) ?? []) {
        if (seenBus.has(b)) continue;
        seenBus.add(b);
        for (const ns of routes[b]) {
          if (ns === target) return buses;
          if (!seenStop.has(ns)) { seenStop.add(ns); q.push(ns); }
        }
      }
    }
  }
  return -1;
}

export {};
