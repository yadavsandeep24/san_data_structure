// Worked code: max depth
// Source: book/part-iii/09-trees-basics.md
import DSACommon

func maxDepth(_ root: TreeNode?) -> Int {
    guard let root else { return 0 }
    return 1 + max(maxDepth(root.left), maxDepth(root.right))
}
