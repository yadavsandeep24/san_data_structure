// Longest palindromic substring — expand around center
// Source: book/part-vii/26-strings.md

func longestPalindrome(_ s: String) -> String {
    let chars = Array(s)
    guard !chars.isEmpty else { return "" }
    var start = 0, end = 0
    func expand(_ l: Int, _ r: Int) -> (Int, Int) {
        var L = l, R = r
        while L >= 0 && R < chars.count && chars[L] == chars[R] {
            L -= 1; R += 1
        }
        return (L + 1, R - 1)
    }
    for i in chars.indices {
        let (a, b) = expand(i, i)
        let (c, d) = expand(i, i + 1)
        if b - a > end - start { start = a; end = b }
        if d - c > end - start { start = c; end = d }
    }
    return String(chars[start...end])
}
