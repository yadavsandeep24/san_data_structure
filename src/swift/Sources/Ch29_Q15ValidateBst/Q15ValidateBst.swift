// Q15. Validate BST
// Source: book/part-viii/29-interview-questions-q11-q20.md
import DSACommon

func isValidBST(_ root: TreeNode?) -> Bool {
    func go(_ n: TreeNode?, _ lo: Int?, _ hi: Int?) -> Bool {
        guard let n else { return true }
        if let lo, n.val <= lo { return false }
        if let hi, n.val >= hi { return false }
        return go(n.left, lo, n.val) && go(n.right, n.val, hi)
    }
    return go(root, nil, nil)
}
