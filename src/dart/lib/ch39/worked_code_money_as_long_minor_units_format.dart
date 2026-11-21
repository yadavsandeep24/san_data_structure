// Worked code (a) — Money as Long minor units + format
// Source: book/part-ix/39-money-idempotency-reliability.md

class Money {
  final int amountMinor; // fit in 64-bit; use package:fixnum if you need explicit Int64
  final String currencyCode;

  Money(this.amountMinor, this.currencyCode) {
    assert(currencyCode.length == 3);
  }

  Money operator +(Money o) {
    assert(currencyCode == o.currencyCode);
    return Money(amountMinor + o.amountMinor, currencyCode);
  }

  String format({String locale = 'en_US'}) {
    final major = amountMinor / 100;
    // Prefer intl NumberFormat.simpleCurrency in apps:
    // NumberFormat.simpleCurrency(name: currencyCode, locale: locale).format(major);
    return '$currencyCode ${major.toStringAsFixed(2)}';
  }
}
