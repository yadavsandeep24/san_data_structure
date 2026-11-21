// Longest palindromic substring — expand around center
// Source: book/part-vii/26-strings.md

String longestPalindrome(String s) {
  if (s.isEmpty) return '';
  var start = 0, end = 0;
  (int, int) expand(int l, int r) {
    var L = l, R = r;
    while (L >= 0 && R < s.length && s[L] == s[R]) {
      L--;
      R++;
    }
    return (L + 1, R - 1);
  }
  for (var i = 0; i < s.length; i++) {
    final (a, b) = expand(i, i);
    final (c, d) = expand(i, i + 1);
    if (b - a > end - start) {
      start = a;
      end = b;
    }
    if (d - c > end - start) {
      start = c;
      end = d;
    }
  }
  return s.substring(start, end + 1);
}
