// Q12 — Justify text (Swift / Dart)
// Source: solutions/ch42/README.md

func justify(_ words: [String], _ width: Int) -> [String] {
    var lines: [String] = []
    var i = 0
    while i < words.count {
        var j = i, len = 0
        while j < words.count && len + words[j].count + (j - i) <= width { len += words[j].count; j += 1 }
        precondition(j > i, "word longer than width: \(words[i])")
        let gaps = j - i - 1
        if j == words.count || gaps == 0 {
            let s = words[i..<j].joined(separator: " ")       // last line or one word: left-aligned
            lines.append(s + String(repeating: " ", count: width - s.count))
        } else {
            let spaces = width - len, each = spaces / gaps, extra = spaces % gaps
            var line = ""
            for k in i..<j {
                line += words[k]
                if k < j - 1 { line += String(repeating: " ", count: each + (k - i < extra ? 1 : 0)) }
            }
            lines.append(line)
        }
        i = j
    }
    return lines
}
