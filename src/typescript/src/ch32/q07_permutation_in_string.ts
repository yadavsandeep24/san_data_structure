// Q7. Permutation in String (Scrambled Code Search)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

function checkInclusion(s1: string, s2: string): boolean {
  if (s1.length > s2.length) return false;
  const need = new Array<number>(26).fill(0);
  for (const c of s1) need[c.charCodeAt(0) - 97]++;
  let missing = s1.length;
  for (let i = 0; i < s2.length; i++) {
    if (need[s2.charCodeAt(i) - 97]-- > 0) missing--;
    if (i >= s1.length && ++need[s2.charCodeAt(i - s1.length) - 97] > 0) missing++;
    if (missing === 0) return true;
  }
  return false;
}

export {};
