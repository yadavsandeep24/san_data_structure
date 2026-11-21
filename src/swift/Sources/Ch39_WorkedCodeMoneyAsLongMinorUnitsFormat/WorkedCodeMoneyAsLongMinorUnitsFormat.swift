// Worked code (a) — Money as Long minor units + format
// Source: book/part-ix/39-money-idempotency-reliability.md
import Foundation

struct Money: Equatable {
    let amountMinor: Int64
    let currencyCode: String // ISO 4217

    init(amountMinor: Int64, currencyCode: String) {
        precondition(currencyCode.count == 3)
        self.amountMinor = amountMinor
        self.currencyCode = currencyCode
    }

    static func + (a: Money, b: Money) -> Money {
        precondition(a.currencyCode == b.currencyCode)
        return Money(amountMinor: a.amountMinor + b.amountMinor, currencyCode: a.currencyCode)
    }

    func formatted(locale: Locale = .current) -> String {
        let n = NSDecimalNumber(mantissa: UInt64(abs(amountMinor)), exponent: -2, isNegative: amountMinor < 0)
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = currencyCode
        f.locale = locale
        return f.string(from: n) ?? "\(amountMinor)"
    }
}
