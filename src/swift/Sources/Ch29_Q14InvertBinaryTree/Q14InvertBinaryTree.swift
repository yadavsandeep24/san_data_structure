// Q14. Invert Binary Tree
// Source: book/part-viii/29-interview-questions-q11-q20.md
import DSACommon

func invertTree(_ root: TreeNode?) -> TreeNode? {
    guard let r = root else { return nil }
    let tmp = r.left
    r.left = invertTree(r.right)
    r.right = invertTree(tmp)
    return r
}
