// P2: Remove k digits
// Source: solutions/ch16/README.md

func removeKdigits(_ num: String, _ k: Int) -> String {
    var remaining = k
    var stack: [Character] = []
    for c in num {
        while remaining > 0, let top = stack.last, top > c {
            stack.removeLast()
            remaining -= 1
        }
        stack.append(c)
    }
    stack.removeLast(remaining)
    let result = String(stack.drop(while: { $0 == "0" }))
    return result.isEmpty ? "0" : result
}
