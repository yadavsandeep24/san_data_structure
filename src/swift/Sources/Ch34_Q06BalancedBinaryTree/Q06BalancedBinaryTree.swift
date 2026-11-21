// Q6. Balanced Binary Tree (Layout Depth Check)
// Source: book/part-viii/34-linked-lists-trees.md
import DSACommon

func isBalanced(_ root: TreeNode?) -> Bool {
    func height(_ node: TreeNode?) -> Int { // -1 means "already unbalanced"
        guard let node = node else { return 0 }
        let l = height(node.left)
        if l == -1 { return -1 }
        let r = height(node.right)
        if r == -1 || abs(l - r) > 1 { return -1 }
        return 1 + max(l, r)
    }
    return height(root) != -1
}
