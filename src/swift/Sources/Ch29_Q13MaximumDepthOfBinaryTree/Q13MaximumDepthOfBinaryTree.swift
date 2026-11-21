// Q13. Maximum Depth of Binary Tree
// Source: book/part-viii/29-interview-questions-q11-q20.md

class TreeNode {
    var val: Int; var left: TreeNode?; var right: TreeNode?
    init(_ val: Int) { self.val = val }
}
func maxDepth(_ root: TreeNode?) -> Int {
    guard let r = root else { return 0 }
    return 1 + max(maxDepth(r.left), maxDepth(r.right))
}
