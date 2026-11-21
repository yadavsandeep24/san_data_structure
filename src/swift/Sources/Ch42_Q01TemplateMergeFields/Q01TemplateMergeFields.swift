// Q1. Template Merge Fields (Envelope Email Body)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

struct TemplateError: Error { let message: String }

func render(
    _ t: String,
    _ values: [String: String],
    onMissing: (String) -> String = { "{{\($0)}}" }
) throws -> String {
    let c = Array(t)
    func startsWith(_ p: String, at i: Int) -> Bool {
        let p = Array(p)
        return i + p.count <= c.count && Array(c[i..<i + p.count]) == p
    }
    var out = ""
    var i = 0
    while i < c.count {
        if startsWith("\\{{", at: i) {
            out += "{{"; i += 3
        } else if startsWith("{{", at: i) {
            var end = i + 2
            while end < c.count && !startsWith("}}", at: end) { end += 1 }
            guard end < c.count else { throw TemplateError(message: "Unclosed field at index \(i)") }
            let key = String(c[(i + 2)..<end].drop(while: \.isWhitespace).reversed().drop(while: \.isWhitespace).reversed())
            out += values[key] ?? onMissing(key)
            i = end + 2
        } else {
            out.append(c[i]); i += 1
        }
    }
    return out
}
