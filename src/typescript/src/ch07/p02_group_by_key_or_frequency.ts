// P2: Group by key or frequency
// Source: solutions/ch07/README.md

function groupAnagrams(strs: string[]): string[][] {
  const map = new Map<string, string[]>();
  for (const s of strs) {
    const key = [...s].sort().join('');
    const bucket = map.get(key);
    if (bucket) bucket.push(s);
    else map.set(key, [s]);
  }
  return [...map.values()];
}

export {};
