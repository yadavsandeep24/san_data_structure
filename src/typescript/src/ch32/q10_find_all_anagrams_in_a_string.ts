// Q10. Find All Anagrams in a String (Every Scrambled Match)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

function findAnagrams(s: string, p: string): number[] {
  const out: number[] = [];
  if (p.length > s.length) return out;
  const need = new Array<number>(26).fill(0);
  for (const c of p) need[c.charCodeAt(0) - 97]++;
  let missing = p.length;
  for (let i = 0; i < s.length; i++) {
    if (need[s.charCodeAt(i) - 97]-- > 0) missing--;
    if (i >= p.length && ++need[s.charCodeAt(i - p.length) - 97] > 0) missing++;
    if (missing === 0) out.push(i - p.length + 1);
  }
  return out;
}

export {};
