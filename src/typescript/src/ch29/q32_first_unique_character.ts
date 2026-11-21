// Q32. First Unique Character
// Source: book/part-viii/29-interview-questions-q31-q40.md

function firstUniqChar(s: string): number {
  const freq = new Map<string, number>();
  for (let i = 0; i < s.length; i++) {
    const c = s[i];
    freq.set(c, (freq.get(c) ?? 0) + 1);
  }
  for (let i = 0; i < s.length; i++) if (freq.get(s[i]) === 1) return i;
  return -1;
}

export {};
