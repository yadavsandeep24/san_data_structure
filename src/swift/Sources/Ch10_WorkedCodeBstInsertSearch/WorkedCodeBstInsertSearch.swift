// Worked code: BST insert + search (Swift)
// Source: book/part-iii/10-trees-practical.md

final class TreeNode {
    var value: Int
    var left: TreeNode?
    var right: TreeNode?
    init(_ value: Int) { self.value = value }
}

func insert(_ root: TreeNode?, _ key: Int) -> TreeNode {
    guard let root else { return TreeNode(key) }
    if key < root.value { root.left = insert(root.left, key) }
    else if key > root.value { root.right = insert(root.right, key) }
    return root
}

func search(_ root: TreeNode?, _ key: Int) -> TreeNode? {
    var cur = root
    while let n = cur {
        if key == n.value { return n }
        cur = key < n.value ? n.left : n.right
    }
    return nil
}
