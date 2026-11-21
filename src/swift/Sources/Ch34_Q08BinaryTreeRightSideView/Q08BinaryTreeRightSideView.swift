// Q8. Binary Tree Right Side View (What the Right Edge Shows)
// Source: book/part-viii/34-linked-lists-trees.md
import DSACommon

func rightSideView(_ root: TreeNode?) -> [Int] {
    var out: [Int] = []
    guard let root = root else { return out }
    var level = [root]
    while let last = level.last {
        out.append(last.val) // last node of this level
        var next: [TreeNode] = []
        for n in level {
            if let l = n.left { next.append(l) }
            if let r = n.right { next.append(r) }
        }
        level = next
    }
    return out
}
