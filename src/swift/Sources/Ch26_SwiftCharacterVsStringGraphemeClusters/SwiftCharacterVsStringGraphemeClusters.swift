// Swift: Character vs String, grapheme clusters
// Source: book/part-vii/26-strings.md

let flag = "🇺🇸"
func example() {
    flag.count           // 1  (one Character / grapheme)
    flag.unicodeScalars.count  // 2
    Array(flag.utf16).count    // 4  (UTF-16 code units)
}
