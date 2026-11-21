// Q7. Subtree of Another Tree (Find a Component Pattern)
// Source: book/part-viii/34-linked-lists-trees.md
import DSACommon

func isSubtree(_ root: TreeNode?, _ subRoot: TreeNode?) -> Bool {
    func same(_ a: TreeNode?, _ b: TreeNode?) -> Bool {
        guard let a = a, let b = b else { return a == nil && b == nil }
        return a.val == b.val && same(a.left, b.left) && same(a.right, b.right)
    }
    guard let subRoot = subRoot else { return true }
    guard let root = root else { return false }
    return same(root, subRoot) || isSubtree(root.left, subRoot) || isSubtree(root.right, subRoot)
}
