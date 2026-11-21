// P2: Clone graph
// Source: solutions/ch11/README.md

final class Node {
    var val: Int
    var neighbors: [Node]
    init(_ val: Int) { self.val = val; self.neighbors = [] }
}

func cloneGraph(_ node: Node?) -> Node? {
    guard let node else { return nil }
    var map = [ObjectIdentifier: Node]()
    func dfs(_ n: Node) -> Node {
        let id = ObjectIdentifier(n)
        if let c = map[id] { return c }
        let copy = Node(n.val)
        map[id] = copy
        copy.neighbors = n.neighbors.map { dfs($0) }
        return copy
    }
    return dfs(node)
}
