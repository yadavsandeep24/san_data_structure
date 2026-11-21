// Q3. Group Anagrams (Facet Grouping)
// Source: book/part-viii/29-interview-questions-q01-q10.md

function groupAnagrams(strs: string[]): string[][] {
  const m = new Map<string, string[]>();
  for (const s of strs) {
    const k = s.split("").sort().join("");
    if (!m.has(k)) m.set(k, []);
    m.get(k)!.push(s);
  }
  return [...m.values()];
}

export {};
