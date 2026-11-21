// Q17. Lowest Common Ancestor of BST
// Source: book/part-viii/29-interview-questions-q11-q20.md
import DSACommon

func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
    var cur = root
    let a = p!.val, b = q!.val
    while let c = cur {
        if a < c.val && b < c.val { cur = c.left }
        else if a > c.val && b > c.val { cur = c.right }
        else { return c }
    }
    return nil
}
