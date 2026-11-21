// P2: Longest palindromic substring
// Source: solutions/ch26/README.md

function longestPalindrome(s: string): string {
  if (!s) return "";
  let start = 0, end = 0;
  const expand = (l: number, r: number): [number, number] => {
    while (l >= 0 && r < s.length && s[l] === s[r]) {
      l--;
      r++;
    }
    return [l + 1, r - 1];
  };
  for (let i = 0; i < s.length; i++) {
    const [a, b] = expand(i, i);
    const [c, d] = expand(i, i + 1);
    if (b - a > end - start) {
      start = a;
      end = b;
    }
    if (d - c > end - start) {
      start = c;
      end = d;
    }
  }
  return s.slice(start, end + 1);
}

export {};
