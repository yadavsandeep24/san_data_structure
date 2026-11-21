// Binary Search Tree (BST)
// Source: book/part-iii/10-trees-practical.md
import DSACommon

func search(_ root: TreeNode?, _ key: Int) -> TreeNode? {
    var cur = root
    while let n = cur {
        if key == n.value { return n }
        cur = key < n.value ? n.left : n.right
    }
    return nil
}

func insert(_ root: TreeNode?, _ key: Int) -> TreeNode {
    guard let root else { return TreeNode(key) }
    if key < root.value { root.left = insert(root.left, key) }
    else if key > root.value { root.right = insert(root.right, key) }
    // equal: ignore or define multiset policy
    return root
}
