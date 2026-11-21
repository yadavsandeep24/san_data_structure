// Worked example 2: online price span (answer after popping)
// Source: book/part-iv/16-monotonic-stack-deque.md

final class PriceSpan {
    private var stack: [(price: Int, span: Int)] = []
    func next(_ price: Int) -> Int {
        var span = 1
        while let top = stack.last, top.price <= price {
            span += top.span
            stack.removeLast()
        }
        stack.append((price, span))
        return span
    }
}
