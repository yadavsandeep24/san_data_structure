// Q11. Longest Substring with At Most K Distinct Characters
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

int lengthOfLongestSubstringKDistinct(String s, int k) {
  if (k == 0) return 0;
  final freq = <String, int>{};
  var lo = 0, best = 0;
  for (var hi = 0; hi < s.length; hi++) {
    freq[s[hi]] = (freq[s[hi]] ?? 0) + 1;
    while (freq.length > k) {
      final c = s[lo++];
      freq[c] = freq[c]! - 1;
      if (freq[c] == 0) freq.remove(c);
    }
    best = best > (hi - lo + 1) ? best : (hi - lo + 1);
  }
  return best;
}
