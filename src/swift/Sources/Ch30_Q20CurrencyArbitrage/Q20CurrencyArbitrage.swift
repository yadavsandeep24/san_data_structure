// Q20 — Currency arbitrage (Swift / Dart)
// Source: solutions/ch30/README.md
import Foundation

func hasArbitrage(_ pairs: [(String, String, Double)]) -> Bool {
    var nodes = Set<String>()
    for (a, b, _) in pairs { nodes.insert(a); nodes.insert(b) }
    let list = Array(nodes)
    let idx = Dictionary(uniqueKeysWithValues: list.enumerated().map { ($1, $0) })
    let n = list.count
    let edges = pairs.map { (a, b, rate) in (idx[a]!, idx[b]!, -log(rate)) }
    var dist = Array(repeating: 0.0, count: n)
    for _ in 0..<max(0, n - 1) {
        for (u, v, w) in edges where dist[v] > dist[u] + w { dist[v] = dist[u] + w }
    }
    for (u, v, w) in edges where dist[v] > dist[u] + w + 1e-12 { return true }
    return false
}
