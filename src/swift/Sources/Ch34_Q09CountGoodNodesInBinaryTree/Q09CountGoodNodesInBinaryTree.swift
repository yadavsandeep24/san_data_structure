// Q9. Count Good Nodes in Binary Tree (Record-High Checkpoints)
// Source: book/part-viii/34-linked-lists-trees.md
import DSACommon

func goodNodes(_ root: TreeNode?) -> Int {
    func dfs(_ node: TreeNode?, _ maxSoFar: Int) -> Int {
        guard let node = node else { return 0 }
        let good = node.val >= maxSoFar ? 1 : 0
        let next = max(maxSoFar, node.val)
        return good + dfs(node.left, next) + dfs(node.right, next)
    }
    return dfs(root, Int.min)
}
