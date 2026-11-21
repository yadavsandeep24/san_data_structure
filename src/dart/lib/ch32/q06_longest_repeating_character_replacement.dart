// Q6. Longest Repeating Character Replacement (Fix k Typos in a Streak)
// Source: book/part-viii/32-two-pointers-windows-intervals.md
import 'dart:math';

int characterReplacement(String s, int k) {
  final count = List<int>.filled(26, 0);
  var left = 0;
  var maxFreq = 0;
  var best = 0;
  for (var right = 0; right < s.length; right++) {
    maxFreq = max(maxFreq, ++count[s.codeUnitAt(right) - 65]);
    while (right - left + 1 - maxFreq > k) {
      count[s.codeUnitAt(left) - 65]--;
      left++;
    }
    best = max(best, right - left + 1);
  }
  return best;
}
