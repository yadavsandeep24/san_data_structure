// Traversals
// Source: book/part-iii/09-trees-basics.md
import DSACommon

func preorder(_ n: TreeNode?, _ visit: (Int) -> Void) {
    guard let n else { return }
    visit(n.value)
    preorder(n.left, visit)
    preorder(n.right, visit)
}

func inorder(_ n: TreeNode?, _ visit: (Int) -> Void) {
    guard let n else { return }
    inorder(n.left, visit)
    visit(n.value)
    inorder(n.right, visit)
}

func postorder(_ n: TreeNode?, _ visit: (Int) -> Void) {
    guard let n else { return }
    postorder(n.left, visit)
    postorder(n.right, visit)
    visit(n.value)
}

func levelOrder(_ root: TreeNode?) -> [[Int]] {
    guard let root else { return [] }
    var res: [[Int]] = []
    var q = [root]
    var head = 0                      // index-as-queue: O(1) dequeue
    while head < q.count {
        let end = q.count
        var level: [Int] = []
        while head < end {
            let node = q[head]; head += 1
            level.append(node.value)
            if let l = node.left { q.append(l) }
            if let r = node.right { q.append(r) }
        }
        res.append(level)
    }
    return res
}
