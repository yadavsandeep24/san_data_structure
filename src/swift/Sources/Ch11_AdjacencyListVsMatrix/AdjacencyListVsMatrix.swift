// Adjacency list vs matrix
// Source: book/part-iii/11-graphs-intro.md

// Undirected: add both ways
var g: [Int: [Int]] = [:]
func addEdge(_ u: Int, _ v: Int) {
    g[u, default: []].append(v)
    g[v, default: []].append(u)
}
