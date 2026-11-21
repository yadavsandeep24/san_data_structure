// P2: Invert binary tree
// Source: solutions/ch09/README.md
import DSACommon

func invertTree(_ root: TreeNode?) -> TreeNode? {
    guard let root else { return nil }
    let tmp = root.left
    root.left = invertTree(root.right)
    root.right = invertTree(tmp)
    return root
}
