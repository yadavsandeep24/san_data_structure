// Q10 — Kth smallest element in a BST (Swift / Dart)
// Source: solutions/ch34/README.md
import DSACommon

func kthSmallest(_ root: TreeNode?, _ k: Int) -> Int {
    var stack: [TreeNode] = []
    var cur = root, count = 0
    while cur != nil || !stack.isEmpty {
        while let c = cur { stack.append(c); cur = c.left } // walk left
        let node = stack.removeLast()
        count += 1
        if count == k { return node.val } // in-order is ascending
        cur = node.right
    }
    fatalError("k > number of nodes")
}
