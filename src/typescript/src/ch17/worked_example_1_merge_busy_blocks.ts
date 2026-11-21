// Worked example 1: merge busy blocks
// Source: book/part-iv/17-intervals-sweep-line.md

function mergeBusy(blocks: [number, number][]): [number, number][] {
  const sorted = [...blocks].sort((a, b) => a[0] - b[0]);
  const out: [number, number][] = [];
  for (const [s, e] of sorted) {
    const last = out[out.length - 1];
    if (last && s <= last[1]) last[1] = Math.max(last[1], e);
    else out.push([s, e]);
  }
  return out;
}

export {};
