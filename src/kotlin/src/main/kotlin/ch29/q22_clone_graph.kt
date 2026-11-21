// Q22. Clone Graph
// Source: book/part-viii/29-interview-questions-q21-q30.md
package ch29.q22_clone_graph

class GraphNode(var `val`: Int, val neighbors: MutableList<GraphNode> = mutableListOf())
fun cloneGraph(node: GraphNode?): GraphNode? {
    if (node == null) return null
    val map = HashMap<GraphNode, GraphNode>() // identity keys: no equals override
    fun dfs(n: GraphNode): GraphNode {
        map[n]?.let { return it }
        val c = GraphNode(n.`val`)
        map[n] = c
        for (nb in n.neighbors) c.neighbors.add(dfs(nb))
        return c
    }
    return dfs(node)
}
