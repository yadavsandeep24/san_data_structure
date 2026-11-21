// JSON as a tree
// Source: book/part-iii/10-trees-practical.md

// JSONSerialization output: [String: Any] objects, [Any] arrays, scalars
func flatten(_ node: Any?, _ prefix: String = "") -> [String: Any?] {
    var out: [String: Any?] = [:]
    func walk(_ n: Any?, _ path: String) {
        if let obj = n as? [String: Any] {
            if obj.isEmpty && !path.isEmpty { out[path] = obj }
            for (k, v) in obj { walk(v, path.isEmpty ? k : "\(path).\(k)") }
        } else if let arr = n as? [Any] {
            if arr.isEmpty && !path.isEmpty { out[path] = arr }
            for (i, v) in arr.enumerated() { walk(v, "\(path)[\(i)]") }
        } else {
            out[path] = .some(n)
        }
    }
    walk(node, prefix)
    return out
}
