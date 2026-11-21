// P3: Flatten nested map keys
// Source: solutions/ch10/README.md

func flatten(_ node: Any, prefix: String = "") -> [String: Any?] {
    var out: [String: Any?] = [:]
    func walk(_ n: Any, _ path: String) {
        if let dict = n as? [String: Any] {
            if dict.isEmpty && !path.isEmpty { out[path] = dict }
            for (k, v) in dict {
                let next = path.isEmpty ? k : "\(path).\(k)"
                walk(v, next)
            }
        } else if let arr = n as? [Any] {
            if arr.isEmpty && !path.isEmpty { out[path] = arr }
            for (i, v) in arr.enumerated() {
                walk(v, "\(path)[\(i)]")
            }
        } else {
            out[path] = n
        }
    }
    walk(node, prefix)
    return out
}
