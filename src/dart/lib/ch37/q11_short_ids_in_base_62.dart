// Q11. Short IDs in Base 62 (Signing Link Codes)
// Source: book/part-viii/37-math-and-number-drills.md

const String alphabet = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';

String toBase62(int value) {
  if (value < 0) throw ArgumentError('negative');
  if (value == 0) return '0';
  final sb = <String>[];
  for (var v = value; v > 0; v ~/= 62) {
    sb.add(alphabet[v % 62]);
  }
  return sb.reversed.join();
}

int fromBase62(String text) {
  if (text.isEmpty) throw ArgumentError('empty code');
  var value = BigInt.zero;                           // BigInt can't wrap; check the range each step
  for (final c in text.split('')) {
    final digit = alphabet.indexOf(c);
    if (digit < 0) throw ArgumentError('not base62: $c');
    value = value * BigInt.from(62) + BigInt.from(digit);
    if (!value.isValidInt) throw RangeError('code too large');
  }
  return value.toInt();
}
