// Q22. Clone Graph
// Source: book/part-viii/29-interview-questions-q21-q30.md

final class GraphNode {
    var val: Int
    var neighbors: [GraphNode]
    init(_ val: Int, _ neighbors: [GraphNode] = []) { self.val = val; self.neighbors = neighbors }
}
func cloneGraph(_ node: GraphNode?) -> GraphNode? {
    guard let node else { return nil }
    var map: [ObjectIdentifier: GraphNode] = [:]   // identity keys
    func dfs(_ n: GraphNode) -> GraphNode {
        if let c = map[ObjectIdentifier(n)] { return c }
        let c = GraphNode(n.val)
        map[ObjectIdentifier(n)] = c
        for nb in n.neighbors { c.neighbors.append(dfs(nb)) }
        return c
    }
    return dfs(node)
}
