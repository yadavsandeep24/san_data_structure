// Q12. Random Sample from a Stream (Reservoir Sampling of Audit Events)
// Source: book/part-viii/37-math-and-number-drills.md

// rand() returns a float in [0, 1); pass a seeded one in tests.
function reservoirSample<T>(items: Iterable<T>, k: number, rand: () => number = Math.random): T[] {
  const reservoir: T[] = [];
  let i = 0;
  for (const item of items) {
    if (i < k) reservoir.push(item);
    else {
      const j = Math.floor(rand() * (i + 1));        // keep item i with probability k / (i + 1)
      if (j < k) reservoir[j] = item;
    }
    i++;
  }
  return reservoir;
}

export {};
