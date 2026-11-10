# Chapter 35 — Solution Index & Extra Ports

Full **Kotlin + TypeScript** solutions live inline in [`book/part-x/35-linked-lists-trees.md`](../../book/part-x/35-linked-lists-trees.md). The chapter now shows all four languages inline; this file adds a timed-review index and repeats the **Swift/Dart** ports for three of the most interview-heavy problems.

| # | Title | Topic | One-line approach |
|---|-------|-------|-------------------|
| [Q1](../../book/part-x/35-linked-lists-trees.md#q1-reorder-list-interleave-oldest-and-newest) | Reorder List | Linked list (middle, reverse, merge) | Middle (slow/fast) → reverse 2nd half → weave |
| [Q2](../../book/part-x/35-linked-lists-trees.md#q2-remove-nth-node-from-end-of-list-drop-the-nth-latest-notification) | Remove Nth Node From End of List | Linked list (two pointers) | Dummy + gap of n; trail stops before target |
| [Q3](../../book/part-x/35-linked-lists-trees.md#q3-copy-list-with-random-pointer-deep-copy-a-linked-playlist) | Copy List with Random Pointer | Linked list + hash map | Map original → copy; wire next/random in pass 2 |
| [Q4](../../book/part-x/35-linked-lists-trees.md#q4-add-two-numbers-digit-list-amount-sum) | Add Two Numbers | Linked list (carry) | Column addition with carry while any list or carry left |
| [Q5](../../book/part-x/35-linked-lists-trees.md#q5-diameter-of-binary-tree-longest-path-in-a-view-tree) | Diameter of Binary Tree | Tree DFS (post-order) | Post-order height; best = max(l + r) |
| [Q6](../../book/part-x/35-linked-lists-trees.md#q6-balanced-binary-tree-layout-depth-check) | Balanced Binary Tree | Tree DFS (post-order) | Post-order height with −1 sentinel for unbalanced |
| [Q7](../../book/part-x/35-linked-lists-trees.md#q7-subtree-of-another-tree-find-a-component-pattern) | Subtree of Another Tree | Tree recursion | sameTree at every node (serialize + KMP for O(m+n)) |
| [Q8](../../book/part-x/35-linked-lists-trees.md#q8-binary-tree-right-side-view-what-the-right-edge-shows) | Binary Tree Right Side View | BFS level order | BFS; keep last node per level |
| [Q9](../../book/part-x/35-linked-lists-trees.md#q9-count-good-nodes-in-binary-tree-record-high-checkpoints) | Count Good Nodes in Binary Tree | Tree DFS with path state | DFS carrying maxSoFar; good if val ≥ maxSoFar |
| [Q10](../../book/part-x/35-linked-lists-trees.md#q10-kth-smallest-element-in-a-bst-kth-cheapest-in-a-price-index) | Kth Smallest Element in a BST | BST in-order traversal | Iterative in-order; stop at k-th pop |
| [Q11](../../book/part-x/35-linked-lists-trees.md#q11-construct-binary-tree-from-preorder-and-inorder-traversal-rebuild-a-tree-from-two-dumps) | Construct Binary Tree from Preorder and Inorder Traversal | Tree recursion + hash map | Preorder index gives roots; inorder map splits windows |

---

## Shared node classes (Swift / Dart)

### Swift

```swift
final class ListNode {
    var val: Int
    var next: ListNode?
    init(_ val: Int, _ next: ListNode? = nil) { self.val = val; self.next = next }
}

final class TreeNode {
    var val: Int
    var left: TreeNode?
    var right: TreeNode?
    init(_ val: Int) { self.val = val }
}
```

### Dart

```dart
class ListNode {
  int val;
  ListNode? next;
  ListNode(this.val, [this.next]);
}

class TreeNode {
  int val;
  TreeNode? left;
  TreeNode? right;
  TreeNode(this.val);
}
```

---

## Q1 — Reorder list (Swift / Dart)

### Swift

```swift
func reorderList(_ head: ListNode?) {
    guard let head = head, head.next != nil else { return }
    var slow = head, fast: ListNode? = head
    while let f = fast?.next?.next { slow = slow.next!; fast = f } // middle
    var prev: ListNode? = nil, cur = slow.next
    slow.next = nil
    while let c = cur { let nxt = c.next; c.next = prev; prev = c; cur = nxt } // reverse 2nd half
    var a: ListNode? = head, b = prev
    while let x = a, let y = b { // weave
        let xNext = x.next, yNext = y.next
        x.next = y; y.next = xNext
        a = xNext; b = yNext
    }
}
```

### Dart

```dart
void reorderList(ListNode? head) {
  if (head == null || head.next == null) return;
  var slow = head;
  ListNode? fast = head;
  while (fast?.next?.next != null) { // middle
    slow = slow.next!;
    fast = fast!.next!.next;
  }
  ListNode? prev, cur = slow.next;
  slow.next = null;
  while (cur != null) { // reverse 2nd half
    final nxt = cur.next;
    cur.next = prev;
    prev = cur;
    cur = nxt;
  }
  ListNode? a = head, b = prev;
  while (a != null && b != null) { // weave
    final aNext = a.next, bNext = b.next;
    a.next = b;
    b.next = aNext;
    a = aNext;
    b = bNext;
  }
}
```

---

## Q10 — Kth smallest element in a BST (Swift / Dart)

### Swift

```swift
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
```

### Dart

```dart
int kthSmallest(TreeNode? root, int k) {
  final stack = <TreeNode>[];
  var cur = root;
  var count = 0;
  while (cur != null || stack.isNotEmpty) {
    while (cur != null) { // walk left
      stack.add(cur);
      cur = cur.left;
    }
    final node = stack.removeLast();
    if (++count == k) return node.val; // in-order is ascending
    cur = node.right;
  }
  throw ArgumentError('k > number of nodes');
}
```

---

## Q11 — Construct tree from preorder + inorder (Swift / Dart)

### Swift

```swift
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
```

### Dart

```dart
TreeNode? buildTree(List<int> preorder, List<int> inorder) {
  final inIndex = <int, int>{};
  for (var i = 0; i < inorder.length; i++) inIndex[inorder[i]] = i;
  var pre = 0;
  TreeNode? build(int lo, int hi) { // inorder window [lo, hi]
    if (lo > hi) return null;
    final node = TreeNode(preorder[pre++]);
    final mid = inIndex[node.val]!;
    node.left = build(lo, mid - 1);
    node.right = build(mid + 1, hi);
    return node;
  }
  return build(0, inorder.length - 1);
}
```

---

Back to the chapter: [Chapter 35](../../book/part-x/35-linked-lists-trees.md)
