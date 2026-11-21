// Q6 — Fraction to recurring decimal (Swift / Dart)
// Source: solutions/ch37/README.md
import 'dart:math';

String fractionToDecimal(int numerator, int denominator) {
  if (denominator == 0) throw ArgumentError('divide by zero');
  if (numerator == 0) return '0';
  final sb = StringBuffer();
  if ((numerator < 0) != (denominator < 0)) sb.write('-');
  final n = BigInt.from(numerator).abs();            // abs of the min 64-bit int needs BigInt
  final d = BigInt.from(denominator).abs();
  sb.write(n ~/ d);
  var remainder = n % d;
  if (remainder == BigInt.zero) return sb.toString();
  sb.write('.');
  var out = sb.toString();
  final seenAt = <BigInt, int>{};                    // remainder -> where its digit was written
  while (remainder != BigInt.zero) {
    final start = seenAt[remainder];
    if (start != null) return '${out.substring(0, start)}(${out.substring(start)})';
    seenAt[remainder] = out.length;
    remainder *= BigInt.from(10);
    out += (remainder ~/ d).toString();
    remainder %= d;
  }
  return out;
}
