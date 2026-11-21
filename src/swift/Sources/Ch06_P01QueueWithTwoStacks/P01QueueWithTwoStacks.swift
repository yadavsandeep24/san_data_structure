// P1: Queue with two stacks
// Source: solutions/ch06/README.md

final class MyQueue {
    private var inbound: [Int] = []
    private var outbound: [Int] = []

    func push(_ x: Int) { inbound.append(x) }

    func pop() -> Int {
        move()
        return outbound.removeLast()
    }

    func peek() -> Int {
        move()
        return outbound.last!
    }

    func empty() -> Bool { inbound.isEmpty && outbound.isEmpty }

    private func move() {
        if outbound.isEmpty {
            while let v = inbound.popLast() { outbound.append(v) }
        }
    }
}
