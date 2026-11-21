// Group anagrams
// Source: book/part-vii/26-strings.md

function groupAnagrams(strs: string[]): string[][] {
  const map = new Map<string, string[]>();
  for (const s of strs) {
    const key = [...s].sort().join("");
    if (!map.has(key)) map.set(key, []);
    map.get(key)!.push(s);
  }
  return [...map.values()];
}

export {};
