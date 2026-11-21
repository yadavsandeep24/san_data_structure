// Q5. Parse an Integer Strictly, with Overflow Checks (Page Number Input)
// Source: book/part-viii/37-math-and-number-drills.md

const int intMin = -2147483648;                      // 32-bit limits; Dart's own int is 64-bit

int? parseIntStrict(String s) {
  if (s.isEmpty) return null;
  final negative = s[0] == '-';
  final start = (s[0] == '-' || s[0] == '+') ? 1 : 0;
  if (start == s.length) return null;
  var value = 0;                                     // built as a negative, like the Kotlin version
  for (var i = start; i < s.length; i++) {
    final digit = s.codeUnitAt(i) - 48;
    if (digit < 0 || digit > 9) return null;
    if (value < (intMin + digit) ~/ 10) return null; // value * 10 - digit would overflow
    value = value * 10 - digit;
  }
  if (negative) return value;
  return value == intMin ? null : -value;
}
