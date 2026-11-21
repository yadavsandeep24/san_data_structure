// Q3. Redact PII Before Logging (Crash Reports)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

let email = #/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/#
let phone = #/\+?[0-9][0-9\s-]{8,}[0-9]/#

func redact(_ text: String) -> String {
    text.replacing(email) { m in
        let v = m.output
        guard let first = v.first, let at = v.firstIndex(of: "@") else { return String(v) }
        return "\(first)***" + v[at...]
    }.replacing(phone) { m in
        let digits = m.output.filter { $0.isASCII && $0.isNumber }
        return String(repeating: "•", count: max(0, digits.count - 4)) + digits.suffix(4)
    }
}
