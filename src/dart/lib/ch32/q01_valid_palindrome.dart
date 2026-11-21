// Q1. Valid Palindrome (Coupon Code Check)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

bool isPalindrome(String s) {
  int? norm(int c) {
    if ((c >= 0x61 && c <= 0x7a) || (c >= 0x30 && c <= 0x39)) return c;
    if (c >= 0x41 && c <= 0x5a) return c + 0x20;
    return null;
  }

  var i = 0;
  var j = s.length - 1;
  while (i < j) {
    final a = norm(s.codeUnitAt(i));
    final b = norm(s.codeUnitAt(j));
    if (a == null) {
      i++;
    } else if (b == null) {
      j--;
    } else if (a != b) {
      return false;
    } else {
      i++;
      j--;
    }
  }
  return true;
}
