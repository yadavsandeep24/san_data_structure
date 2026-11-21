// P1: Money value object and safe parse/format
// Source: solutions/ch39/README.md
import Foundation

struct Money: Equatable {
    let amountMinor: Int64
    let currencyCode: String

    static func + (a: Money, b: Money) -> Money {
        precondition(a.currencyCode == b.currencyCode)
        return Money(amountMinor: a.amountMinor + b.amountMinor, currencyCode: a.currencyCode)
    }

    func formatted(locale: Locale = .current) -> String {
        let n = NSDecimalNumber(
            mantissa: UInt64(abs(amountMinor)),
            exponent: -2,
            isNegative: amountMinor < 0
        )
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = currencyCode
        f.locale = locale
        return f.string(from: n) ?? "\(amountMinor)"
    }
}

func parseMajorToMinor(_ text: String, scale: Int = 2) -> Int64 {
    let t = text.trimmingCharacters(in: .whitespaces)
    let neg = t.hasPrefix("-")
    let raw = neg ? String(t.dropFirst()) : t
    let parts = raw.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false).map(String.init)
    let whole = Int64(parts[0]) ?? 0
    var pow: Int64 = 1
    for _ in 0..<scale { pow *= 10 }
    let frac: Int64
    if parts.count == 1 { frac = 0 }
    else {
        let padded = parts[1].padding(toLength: scale, withPad: "0", startingAt: 0)
        frac = Int64(padded.prefix(scale)) ?? 0
    }
    let minor = whole * pow + frac
    return neg ? -minor : minor
}
