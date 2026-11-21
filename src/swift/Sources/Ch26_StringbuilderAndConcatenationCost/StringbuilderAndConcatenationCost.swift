// StringBuilder and concatenation cost
// Source: book/part-vii/26-strings.md

func joinCsv(_ parts: [String]) -> String {
    parts.joined(separator: ",") // one allocation sized for the result
}
