// Q10 — Deep-link router (Swift / Dart)
// Source: solutions/ch42/README.md

final class Router<T> {
    private final class Node {
        var kids: [String: Node] = [:]
        var param: (name: String, node: Node)?
        var wildcard: T?
        var value: T?
    }

    private let root = Node()

    private static func segments(_ s: String) -> [String] {
        let path = s.split(separator: "?", maxSplits: 1, omittingEmptySubsequences: false).first ?? ""
        return path.split(separator: "/").map(String.init)
    }

    func add(_ pattern: String, _ value: T) {
        var n = root
        for seg in Router.segments(pattern) {
            if seg == "*" { n.wildcard = value; return }
            if seg.hasPrefix(":") {
                if n.param == nil { n.param = (String(seg.dropFirst()), Node()) }
                n = n.param!.node
            } else {
                if n.kids[seg] == nil { n.kids[seg] = Node() }
                n = n.kids[seg]!
            }
        }
        n.value = value
    }

    /// Static segments beat :params, which beat *. Backtracks if a static branch dead-ends.
    func match(_ path: String) -> (value: T, params: [String: String])? {
        let segs = Router.segments(path)
        func go(_ n: Node, _ i: Int, _ params: [String: String]) -> (value: T, params: [String: String])? {
            if i == segs.count {
                if let v = n.value ?? n.wildcard { return (v, params) }
                return nil
            }
            if let k = n.kids[segs[i]], let m = go(k, i + 1, params) { return m }
            if let p = n.param {
                var next = params; next[p.name] = segs[i]
                if let m = go(p.node, i + 1, next) { return m }
            }
            if let w = n.wildcard { return (w, params) }
            return nil
        }
        return go(root, 0, [:])
    }
}
