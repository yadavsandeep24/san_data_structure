// Q6. Valid Parentheses (Schema or Deep Link Path)
// Source: book/part-viii/29-interview-questions-q01-q10.md

func isValid(_ s: String) -> Bool {
    var st: [Character] = []
    let pair: [Character: Character] = [")": "(", "]": "[", "}": "{"]
    for c in s {
        if "([{".contains(c) { st.append(c) }
        else if st.isEmpty || st.removeLast() != pair[c]! { return false }
    }
    return st.isEmpty
}
