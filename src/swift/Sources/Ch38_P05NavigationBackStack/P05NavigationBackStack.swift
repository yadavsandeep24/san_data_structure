// P5. Navigation Back Stack
// Source: solutions/ch38/README.md

final class NavStack {
    private var stack: [String] = []
    func push(_ r: String) { stack.append(r) }
    func pop() -> String? { stack.popLast() }
    func peek() -> String? { stack.last }
    func replace(_ r: String) { if stack.isEmpty { push(r) } else { stack[stack.count - 1] = r } }
    func popToRoot() { if !stack.isEmpty { stack = [stack[0]] } }
    func snapshot() -> [String] { stack }
}
