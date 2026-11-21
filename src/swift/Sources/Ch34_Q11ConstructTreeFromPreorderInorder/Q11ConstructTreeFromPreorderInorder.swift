// Q11 — Construct tree from preorder + inorder (Swift / Dart)
// Source: solutions/ch34/README.md
import DSACommon

func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
    var inIndex: [Int: Int] = [:]
    for (i, v) in inorder.enumerated() { inIndex[v] = i }
    var pre = 0
    func build(_ lo: Int, _ hi: Int) -> TreeNode? { // inorder window [lo, hi]
        if lo > hi { return nil }
        let node = TreeNode(preorder[pre]); pre += 1
        guard let mid = inIndex[node.val] else { return nil } // value missing from inorder
        node.left = build(lo, mid - 1)
        node.right = build(mid + 1, hi)
        return node
    }
    return build(0, inorder.count - 1)
}
