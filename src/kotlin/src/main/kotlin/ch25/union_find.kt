// Union-Find (Disjoint Set Union)
// Source: book/part-vii/25-graphs-advanced.md
package ch25.union_find

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
