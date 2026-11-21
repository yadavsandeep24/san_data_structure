// View-tree recursion (mobile-shaped)
// Source: book/part-vi/22-recursion-backtracking.md

final class ViewNode {
    let id: String
    var children: [ViewNode]
    init(_ id: String, children: [ViewNode] = []) {
        self.id = id; self.children = children
    }
}

func countLeaves(_ node: ViewNode) -> Int {
    if node.children.isEmpty { return 1 }
    return node.children.reduce(0) { $0 + countLeaves($1) }
}
