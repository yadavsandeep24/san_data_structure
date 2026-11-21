// Q11. Valid Parenthesis String (Template Brackets with Wildcards)
// Source: book/part-viii/35-heaps-tries-greedy.md

func checkValidString(_ s: String) -> Bool {
    var lo = 0, hi = 0 // range of possible open-bracket counts
    for c in s {
        switch c {
        case "(": lo += 1; hi += 1
        case ")": lo -= 1; hi -= 1
        default: lo -= 1; hi += 1 // '*'
        }
        if hi < 0 { return false }
        if lo < 0 { lo = 0 }
    }
    return lo == 0
}
