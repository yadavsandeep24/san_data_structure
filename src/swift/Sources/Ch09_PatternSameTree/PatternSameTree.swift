// Pattern: same tree
// Source: book/part-iii/09-trees-basics.md
import DSACommon

func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
    switch (p, q) {
    case (nil, nil): return true
    case let (p?, q?):
        return p.value == q.value
            && isSameTree(p.left, q.left) && isSameTree(p.right, q.right)
    default: return false
    }
}
