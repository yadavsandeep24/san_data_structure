// P3: Connected components or redundant connection
// Source: solutions/ch25/README.md
package ch25.p03_connected_components_or_redundant_connection

class UnionFind(n: Int) {
    private val parent = IntArray(n) { it }
    private val rank = IntArray(n)
    var components = n
        private set
    fun find(x: Int): Int {
        if (parent[x] != x) parent[x] = find(parent[x])
        return parent[x]
    }
    fun union(a: Int, b: Int): Boolean {
        var ra = find(a)
        var rb = find(b)
        if (ra == rb) return false
        if (rank[ra] < rank[rb]) {
            val t = ra; ra = rb; rb = t
        }
        parent[rb] = ra
        if (rank[ra] == rank[rb]) rank[ra]++
        components--
        return true
    }
}

fun countComponents(n: Int, edges: Array<IntArray>): Int {
    val uf = UnionFind(n)
    for (e in edges) uf.union(e[0], e[1])
    return uf.components
}

fun findRedundantConnection(edges: Array<IntArray>): IntArray {
    val uf = UnionFind(edges.size + 1) // nodes 1..n
    for (e in edges) {
        if (!uf.union(e[0], e[1])) return e
    }
    return intArrayOf()
}
