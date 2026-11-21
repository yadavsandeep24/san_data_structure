// P1: Money value object and safe parse/format
// Source: solutions/ch39/README.md
import 'dart:math';

class Money {
  final int amountMinor;
  final String currencyCode;
  Money(this.amountMinor, this.currencyCode);

  Money operator +(Money o) {
    if (currencyCode != o.currencyCode) throw ArgumentError('currency mismatch');
    return Money(amountMinor + o.amountMinor, currencyCode);
  }
}

int parseMajorToMinor(String text, {int scale = 2}) {
  var t = text.trim();
  final neg = t.startsWith('-');
  if (neg) t = t.substring(1);
  final parts = t.split('.');
  final whole = int.parse(parts[0]);
  var pow = 1;
  for (var i = 0; i < scale; i++) pow *= 10;
  final frac = parts.length == 1
      ? 0
      : int.parse(parts[1].padRight(scale, '0').substring(0, scale));
  final minor = whole * pow + frac;
  return neg ? -minor : minor;
}
