// Q33. Longest Substring Without Repeating Characters
// Source: book/part-viii/29-interview-questions-q31-q40.md

int lengthOfLongestSubstring(String s) {
  final last = <String, int>{};
  var left = 0, best = 0;
  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    final prev = last[c];
    if (prev != null && prev >= left) left = prev + 1;
    last[c] = i;
    if (i - left + 1 > best) best = i - left + 1;
  }
  return best;
}
