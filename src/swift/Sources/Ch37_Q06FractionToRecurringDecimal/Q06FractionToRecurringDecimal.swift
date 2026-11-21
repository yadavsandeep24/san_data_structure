// Q6. Fraction to Recurring Decimal (Fee Split Display)
// Source: book/part-viii/37-math-and-number-drills.md

func fractionToDecimal(_ numerator: Int, _ denominator: Int) -> String {
    precondition(denominator != 0)
    if numerator == 0 { return "0" }
    var out = (numerator < 0) != (denominator < 0) ? "-" : ""
    let n = numerator.magnitude, d = denominator.magnitude   // UInt: |Int.min| fits
    out += String(n / d)
    var remainder = n % d
    if remainder == 0 { return out }
    out += "."
    var digits: [Character] = []
    var seenAt: [UInt: Int] = [:]                       // remainder -> index in digits
    while remainder != 0 {
        if let start = seenAt[remainder] {
            return out + String(digits[..<start]) + "(" + String(digits[start...]) + ")"
        }
        seenAt[remainder] = digits.count
        // remainder * 10 can pass UInt64.max, so use the full 128-bit product
        let (q, r) = d.dividingFullWidth(remainder.multipliedFullWidth(by: 10))
        digits.append(Character(String(q)))
        remainder = r
    }
    return out + String(digits)
}
