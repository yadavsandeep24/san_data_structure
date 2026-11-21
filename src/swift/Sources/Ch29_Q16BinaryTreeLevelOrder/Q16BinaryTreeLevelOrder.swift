// Q16. Binary Tree Level Order
// Source: book/part-viii/29-interview-questions-q11-q20.md
import DSACommon

func levelOrder(_ root: TreeNode?) -> [[Int]] {
    guard let root else { return [] }
    var q: [TreeNode] = [root], out: [[Int]] = []
    var head = 0
    while head < q.count {
        var level: [Int] = []
        let count = q.count - head
        for _ in 0..<count {
            let n = q[head]; head += 1
            level.append(n.val)
            if let l = n.left { q.append(l) }
            if let r = n.right { q.append(r) }
        }
        out.append(level)
    }
    return out
}
