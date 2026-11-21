// Q5. Graph Valid Tree (Folder Hierarchy Sanity Check)
// Source: book/part-viii/36-graphs-dynamic-programming.md
package ch36.q05_graph_valid_tree

fun validTree(n: Int, edges: Array<IntArray>): Boolean {
    if (edges.size != n - 1) return false
    val parent = IntArray(n) { it }
    val size = IntArray(n) { 1 }
    fun find(x: Int): Int {
        var r = x
        while (parent[r] != r) {
            parent[r] = parent[parent[r]] // path halving
            r = parent[r]
        }
        return r
    }
    for ((a, b) in edges) {
        val ra = find(a)
        val rb = find(b)
        if (ra == rb) return false // edge closes a cycle
        if (size[ra] < size[rb]) { // union by size: hang the smaller tree
            parent[ra] = rb
            size[rb] += size[ra]
        } else {
            parent[rb] = ra
            size[ra] += size[rb]
        }
    }
    return true
}
