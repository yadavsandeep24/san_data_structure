// Pattern: invert binary tree
// Source: book/part-iii/09-trees-basics.md
import DSACommon

func invertTree(_ root: TreeNode?) -> TreeNode? {
    guard let root else { return nil }
    let tmp = root.left
    root.left = invertTree(root.right)
    root.right = invertTree(tmp)
    return root
}
