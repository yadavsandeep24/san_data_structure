// Q7. Count Balanced Binary Substrings (Pen-Down Runs)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

function countBinarySubstrings(s: string): number {
  let previous = 0, current = 1, count = 0;
  for (let i = 1; i < s.length; i++) {
    if (s[i] === s[i - 1]) {
      current++;
    } else {
      count += Math.min(previous, current);
      previous = current;
      current = 1;
    }
  }
  return count + Math.min(previous, current);
}

export {};
