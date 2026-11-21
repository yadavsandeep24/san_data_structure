// Q10. Partition Labels (Chunking a Sync Log)
// Source: book/part-viii/35-heaps-tries-greedy.md

function partitionLabels(s: string): number[] {
  const last = new Map<string, number>();
  for (let i = 0; i < s.length; i++) last.set(s[i], i);
  const sizes: number[] = [];
  let start = 0, end = 0;
  for (let i = 0; i < s.length; i++) {
    end = Math.max(end, last.get(s[i])!);
    if (i === end) {
      sizes.push(end - start + 1);
      start = i + 1;
    }
  }
  return sizes;
}

export {};
