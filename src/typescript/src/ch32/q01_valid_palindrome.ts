// Q1. Valid Palindrome (Coupon Code Check)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

function isPalindrome(s: string): boolean {
  const norm = (c: string): string | null => {
    if ((c >= "a" && c <= "z") || (c >= "0" && c <= "9")) return c;
    if (c >= "A" && c <= "Z") return String.fromCharCode(c.charCodeAt(0) + 32);
    return null;
  };
  let i = 0;
  let j = s.length - 1;
  while (i < j) {
    const a = norm(s[i]);
    const b = norm(s[j]);
    if (a === null) i++;
    else if (b === null) j--;
    else if (a !== b) return false;
    else {
      i++;
      j--;
    }
  }
  return true;
}

export {};
