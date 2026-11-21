// P1: Maximum depth
// Source: solutions/ch09/README.md

final class TreeNode {
    var val: Int
    var left: TreeNode?
    var right: TreeNode?
    init(_ val: Int) { self.val = val }
}

func maxDepth(_ root: TreeNode?) -> Int {
    guard let root else { return 0 }
    return 1 + max(maxDepth(root.left), maxDepth(root.right))
}
