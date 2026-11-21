// Q5. Diameter of Binary Tree (Longest Path in a View Tree)
// Source: book/part-viii/34-linked-lists-trees.md
import DSACommon

func diameterOfBinaryTree(_ root: TreeNode?) -> Int {
    var best = 0
    func height(_ node: TreeNode?) -> Int { // nodes on the longest downward path
        guard let node = node else { return 0 }
        let l = height(node.left)
        let r = height(node.right)
        best = max(best, l + r) // longest path bending at this node
        return 1 + max(l, r)
    }
    _ = height(root)
    return best
}
