// Q39. Navigation Back Stack
// Source: book/part-viii/29-interview-questions-q31-q40.md

struct NavStack {
    private var stack: [String] = []
    mutating func push(_ route: String) { stack.append(route) }
    mutating func pop() -> String? { stack.popLast() }
    func peek() -> String? { stack.last }
    mutating func replace(_ route: String) {
        if stack.isEmpty { stack.append(route) } else { stack[stack.count - 1] = route }
    }
    mutating func popToRoot() { if !stack.isEmpty { stack.removeSubrange(1...) } }
    func snapshot() -> [String] { stack }
}
