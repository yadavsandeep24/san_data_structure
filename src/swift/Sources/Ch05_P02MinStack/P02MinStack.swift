// P2: Min stack
// Source: solutions/ch05/README.md

final class MinStack {
    private var vals: [Int] = []
    private var mins: [Int] = []

    func push(_ x: Int) {
        vals.append(x)
        mins.append(mins.last.map { min(x, $0) } ?? x)
    }

    func pop() {
        vals.removeLast()
        mins.removeLast()
    }

    func top() -> Int { vals.last! }
    func getMin() -> Int { mins.last! }
}
