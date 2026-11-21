// P1: Valid parentheses
// Source: solutions/ch05/README.md

func isValid(_ s: String) -> Bool {
    var st: [Character] = []
    let pair: [Character: Character] = [")": "(", "]": "[", "}": "{"]
    for c in s {
        if c == "(" || c == "[" || c == "{" {
            st.append(c)
        } else if st.isEmpty || st.removeLast() != pair[c] {
            return false
        }
    }
    return st.isEmpty
}
