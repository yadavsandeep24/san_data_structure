// Q11. Short IDs in Base 62 (Signing Link Codes)
// Source: book/part-viii/37-math-and-number-drills.md

private let alphabet = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")

func toBase62(_ value: Int) -> String {
    precondition(value >= 0)
    if value == 0 { return "0" }
    var out: [Character] = []
    var v = value
    while v > 0 {
        out.append(alphabet[v % 62])
        v /= 62
    }
    return String(out.reversed())
}

func fromBase62(_ text: String) -> Int? {
    guard !text.isEmpty else { return nil }
    var value = 0
    for c in text {
        guard let digit = alphabet.firstIndex(of: c) else { return nil }   // reject unknown characters
        let (times62, o1) = value.multipliedReportingOverflow(by: 62)
        let (next, o2) = times62.addingReportingOverflow(digit)
        if o1 || o2 { return nil }                      // nil instead of trapping past Int.max
        value = next
    }
    return value
}
