// Adjacency list vs matrix
// Source: book/part-iii/11-graphs-intro.md
package ch11.adjacency_list_vs_matrix

// Undirected: add both ways
val g = HashMap<Int, MutableList<Int>>()
fun addEdge(u: Int, v: Int) {
    g.getOrPut(u) { mutableListOf() }.add(v)
    g.getOrPut(v) { mutableListOf() }.add(u)
}
