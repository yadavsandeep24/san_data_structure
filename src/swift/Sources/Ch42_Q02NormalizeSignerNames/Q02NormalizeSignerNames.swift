// Q2. Normalize Signer Names (Duplicate Recipients)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md
import Foundation

func canonical(_ name: String) -> String {
    let stripped = String(String.UnicodeScalarView(
        name.decomposedStringWithCanonicalMapping.unicodeScalars
            .filter { $0.properties.generalCategory != .nonspacingMark }   // José -> Jose
    ))
    return stripped.lowercased()
        .split(whereSeparator: { $0.isWhitespace || $0 == "," })
        .map(String.init)
        .sorted()                                                          // "Doe, Jane" == "Jane Doe"
        .joined(separator: " ")
}

func duplicateGroups(_ names: [String]) -> [[String]] {
    var order: [String] = []
    var groups: [String: [String]] = [:]
    for n in names {
        let key = canonical(n)
        if groups[key] == nil { order.append(key) }
        groups[key, default: []].append(n)
    }
    return order.compactMap { groups[$0] }.filter { $0.count > 1 }
}
