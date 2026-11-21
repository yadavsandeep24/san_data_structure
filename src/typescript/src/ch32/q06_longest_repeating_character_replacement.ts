// Q6. Longest Repeating Character Replacement (Fix k Typos in a Streak)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

function characterReplacement(s: string, k: number): number {
  const count = new Array<number>(26).fill(0);
  let left = 0;
  let maxFreq = 0;
  let best = 0;
  for (let right = 0; right < s.length; right++) {
    maxFreq = Math.max(maxFreq, ++count[s.charCodeAt(right) - 65]);
    while (right - left + 1 - maxFreq > k) {
      count[s.charCodeAt(left) - 65]--;
      left++;
    }
    best = Math.max(best, right - left + 1);
  }
  return best;
}

export {};
