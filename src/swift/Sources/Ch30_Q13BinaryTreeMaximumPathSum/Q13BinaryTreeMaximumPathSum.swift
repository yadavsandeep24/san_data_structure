// Q13. Binary Tree Maximum Path Sum
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md
import DSACommon

func maxPathSum(_ root: TreeNode?) -> Int {
    var best = Int.min
    func gain(_ n: TreeNode?) -> Int {
        guard let n else { return 0 }
        let l = max(0, gain(n.left))
        let r = max(0, gain(n.right))
        best = max(best, n.val + l + r)
        return n.val + max(l, r)
    }
    _ = gain(root)
    return best
}
