// P3: Same tree
// Source: solutions/ch09/README.md
import DSACommon

func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
    if p == nil && q == nil { return true }
    guard let p, let q, p.val == q.val else { return false }
    return isSameTree(p.left, q.left) && isSameTree(p.right, q.right)
}
