// Q8. Decode Ways (Ambiguous Numeric Codes)
// Source: book/part-viii/36-graphs-dynamic-programming.md

int numDecodings(String s) {
  var prev2 = 1; // dp[i-2]
  var prev1 = s[0] == '0' ? 0 : 1; // dp[i-1]
  for (var i = 2; i <= s.length; i++) {
    var cur = 0;
    if (s[i - 1] != '0') cur += prev1;
    final two = int.parse(s.substring(i - 2, i));
    if (two >= 10 && two <= 26) cur += prev2;
    prev2 = prev1;
    prev1 = cur;
  }
  return prev1;
}
