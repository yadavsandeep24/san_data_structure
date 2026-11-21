// Adjacency list vs matrix
// Source: book/part-iii/11-graphs-intro.md

// Undirected: add both ways

final g = <int, List<int>>{};
void addEdge(int u, int v) {
  g.putIfAbsent(u, () => []).add(v);
  g.putIfAbsent(v, () => []).add(u);
}
