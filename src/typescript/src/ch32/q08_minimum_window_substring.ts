// Q8. Minimum Window Substring (Shortest Log Span Covering All Events)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

function minWindow(s: string, t: string): string {
  if (t.length === 0 || t.length > s.length) return "";
  const need = new Array<number>(128).fill(0);
  for (const c of t) need[c.charCodeAt(0)]++;
  let missing = t.length;
  let left = 0;
  let bestStart = 0;
  let bestLen = Infinity;
  for (let right = 0; right < s.length; right++) {
    if (need[s.charCodeAt(right)]-- > 0) missing--;
    while (missing === 0) {
      if (right - left + 1 < bestLen) {
        bestLen = right - left + 1;
        bestStart = left;
      }
      if (++need[s.charCodeAt(left)] > 0) missing++;
      left++;
    }
  }
  return bestLen === Infinity ? "" : s.slice(bestStart, bestStart + bestLen);
}

export {};
