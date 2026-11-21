// Worked examples (four languages)
// Source: book/part-ii/05-stacks.md

struct Stack<Element> {
    private var data: [Element] = []
    mutating func push(_ x: Element) { data.append(x) }
    mutating func pop() -> Element? { data.popLast() }
    func peek() -> Element? { data.last }
    var isEmpty: Bool { data.isEmpty }
}

func isValid(_ s: String) -> Bool {
    var st: [Character] = []
    let pair: [Character: Character] = [")": "(", "]": "[", "}": "{"]
    for c in s {
        if "([{".contains(c) { st.append(c) }
        else if st.isEmpty || st.removeLast() != pair[c] { return false }
    }
    return st.isEmpty
}

final class MinStack {
    private var vals: [Int] = []
    private var mins: [Int] = []
    func push(_ x: Int) {
        vals.append(x)
        mins.append(mins.last.map { min(x, $0) } ?? x)
    }
    func pop() { vals.removeLast(); mins.removeLast() }
    func top() -> Int { vals.last! }
    func getMin() -> Int { mins.last! }
}
