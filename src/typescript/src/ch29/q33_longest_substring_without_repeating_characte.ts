// Q33. Longest Substring Without Repeating Characters
// Source: book/part-viii/29-interview-questions-q31-q40.md

function lengthOfLongestSubstring(s: string): number {
  const last = new Map<string, number>();
  let left = 0, best = 0;
  for (let i = 0; i < s.length; i++) {
    const c = s[i];
    const prev = last.get(c);
    if (prev !== undefined && prev >= left) left = prev + 1;
    last.set(c, i);
    best = Math.max(best, i - left + 1);
  }
  return best;
}

export {};
