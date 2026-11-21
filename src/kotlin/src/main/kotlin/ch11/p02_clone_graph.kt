// P2: Clone graph
// Source: solutions/ch11/README.md
package ch11.p02_clone_graph

class Node(var `val`: Int) {
    var neighbors: ArrayList<Node?> = ArrayList()
}

fun cloneGraph(node: Node?): Node? {
    if (node == null) return null
    val map = HashMap<Node, Node>()
    fun dfs(n: Node): Node {
        map[n]?.let { return it }
        val copy = Node(n.`val`)
        map[n] = copy
        for (nb in n.neighbors) {
            if (nb != null) copy.neighbors.add(dfs(nb))
        }
        return copy
    }
    return dfs(node)
}
