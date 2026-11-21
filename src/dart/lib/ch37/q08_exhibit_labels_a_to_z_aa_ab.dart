// Q8. Exhibit Labels A to Z, AA, AB (Legal Exhibits)
// Source: book/part-viii/37-math-and-number-drills.md

const int int32Max = 2147483647;                     // same limit as Kotlin's Int

String columnTitle(int number) {
  if (number <= 0 || number > int32Max) throw ArgumentError('need 1..$int32Max');
  final codes = <int>[];
  var n = number;
  while (n > 0) {
    n--;                                             // shift to 0-based: A..Z is 0..25 in each position
    codes.add(65 + n % 26);
    n ~/= 26;
  }
  return String.fromCharCodes(codes.reversed);
}

int columnNumber(String title) {
  if (title.isEmpty) throw ArgumentError('empty label');
  var value = 0;
  for (final c in title.codeUnits) {
    if (c < 65 || c > 90) throw ArgumentError('not a label: $title');
    final digit = c - 64;
    if (value > (int32Max - digit) ~/ 26) throw RangeError('label past $int32Max');
    value = value * 26 + digit;
  }
  return value;
}
