// Q5 — Parse an integer strictly (Swift / Dart)
// Source: solutions/ch37/README.md

func parseIntStrict(_ s: String) -> Int32? {
    let chars = Array(s.utf8)
    guard let first = chars.first else { return nil }
    let negative = first == UInt8(ascii: "-")
    let start = (first == UInt8(ascii: "-") || first == UInt8(ascii: "+")) ? 1 : 0
    if start == chars.count { return nil }
    var value: Int32 = 0                                // built as a negative, like the Kotlin version
    for c in chars[start...] {
        guard c >= UInt8(ascii: "0") && c <= UInt8(ascii: "9") else { return nil }
        let digit = Int32(c - UInt8(ascii: "0"))
        if value < (Int32.min + digit) / 10 { return nil }  // value * 10 - digit would overflow
        value = value * 10 - digit
    }
    if negative { return value }
    return value == Int32.min ? nil : -value
}
