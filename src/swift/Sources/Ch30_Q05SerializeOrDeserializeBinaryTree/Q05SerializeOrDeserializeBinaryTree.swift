// Q5. Serialize or Deserialize Binary Tree
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

final class TreeNode {
    var val: Int
    var left: TreeNode?
    var right: TreeNode?
    init(_ val: Int) { self.val = val }
}

final class Codec {
    func serialize(_ root: TreeNode?) -> String {
        guard let root else { return "#" }
        var q: [TreeNode?] = [root]
        var head = 0
        var out: [String] = []
        while head < q.count {
            let node = q[head]
            head += 1
            guard let n = node else { out.append("#"); continue }
            out.append(String(n.val))
            q.append(n.left)
            q.append(n.right)
        }
        return out.joined(separator: ",")
    }

    func deserialize(_ data: String) -> TreeNode? {
        if data == "#" || data.isEmpty { return nil }
        let parts = data.split(separator: ",", omittingEmptySubsequences: false).map(String.init)
        guard let rootVal = Int(parts[0]) else { return nil }
        let root = TreeNode(rootVal)
        var q: [TreeNode] = [root]
        var head = 0
        var i = 1
        while head < q.count && i < parts.count {
            let n = q[head]
            head += 1
            if let v = Int(parts[i]) { // "#" → nil
                let child = TreeNode(v)
                n.left = child
                q.append(child)
            }
            i += 1
            if i < parts.count, let v = Int(parts[i]) {
                let child = TreeNode(v)
                n.right = child
                q.append(child)
            }
            i += 1
        }
        return root
    }
}
