// Validate BST
// Source: book/part-iii/10-trees-practical.md
import DSACommon

func isValidBST(_ root: TreeNode?) -> Bool {
    func go(_ n: TreeNode?, _ lo: Int?, _ hi: Int?) -> Bool {
        guard let n else { return true }
        if let lo, n.value <= lo { return false }
        if let hi, n.value >= hi { return false }
        return go(n.left, lo, n.value) && go(n.right, n.value, hi)
    }
    return go(root, nil, nil)
}
