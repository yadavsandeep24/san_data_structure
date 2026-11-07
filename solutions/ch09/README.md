# Chapter 9 — Model Solutions

Shared node type (all languages use the same shape):

```text
TreeNode { value: Int, left: TreeNode?, right: TreeNode? }
```

## P1: Maximum depth

### Approach

Recursive definition: empty tree has depth 0; otherwise depth = 1 + max(depth(left), depth(right)). Iterative BFS also works: count levels drained from a queue.

### Complexity

- Time: O(n)
- Space: O(h) recursion, or O(w) for BFS queue

### Edge cases

- `null` root → 0
- Single node → 1
- Skewed tree → depth = n (watch stack limits on mobile for huge n)
- Perfect tree → depth = floor(log2 n) + 1

### Mobile note

Mirrors “how deep is this Compose/SwiftUI subtree?” mental model — and on the Android View side, “how deep is this `ViewGroup` hierarchy?”, where depth costs real measure/layout passes (Chapter 9). For untrusted depth prefer iterative BFS.

### Kotlin

```kotlin
class TreeNode(var value: Int) {
    var left: TreeNode? = null
    var right: TreeNode? = null
}

fun maxDepth(root: TreeNode?): Int {
    if (root == null) return 0
    return 1 + maxOf(maxDepth(root.left), maxDepth(root.right))
}
```

### Swift

```swift
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
```

### Dart

```dart
import 'dart:math';

class TreeNode {
  TreeNode(this.value, [this.left, this.right]);
  int value;
  TreeNode? left;
  TreeNode? right;
}

int maxDepth(TreeNode? root) {
  if (root == null) return 0;
  return 1 + max(maxDepth(root.left), maxDepth(root.right));
}
```

### TypeScript

```typescript
class TreeNode {
  val: number;
  left: TreeNode | null;
  right: TreeNode | null;
  constructor(val = 0, left: TreeNode | null = null, right: TreeNode | null = null) {
    this.val = val; this.left = left; this.right = right;
  }
}

function maxDepth(root: TreeNode | null): number {
  if (!root) return 0;
  return 1 + Math.max(maxDepth(root.left), maxDepth(root.right));
}
```

---

## P2: Invert binary tree

### Approach

At each node, swap `left` and `right`, then recurse (or recurse first then swap — both fine). BFS: dequeue, swap children, enqueue children.

### Complexity

- Time: O(n)
- Space: O(h) or O(w)

### Edge cases

- Empty tree → null
- Only left child → becomes only right child
- Already symmetric — still swaps (idempotent only after two inverts)

### Mobile note

Cute interview classic; also a reminder that UI trees are mutable on Android Views / UIKit but often rebuilt immutably in Compose / SwiftUI / Flutter / RN — “invert” there means constructing a mirrored structure, not mutating in place.

### Kotlin

```kotlin
fun invertTree(root: TreeNode?): TreeNode? {
    if (root == null) return null
    val tmp = root.left
    root.left = invertTree(root.right)
    root.right = invertTree(tmp)
    return root
}
```

### Swift

```swift
func invertTree(_ root: TreeNode?) -> TreeNode? {
    guard let root else { return nil }
    let tmp = root.left
    root.left = invertTree(root.right)
    root.right = invertTree(tmp)
    return root
}
```

### Dart

```dart
TreeNode? invertTree(TreeNode? root) {
  if (root == null) return null;
  final tmp = root.left;
  root.left = invertTree(root.right);
  root.right = invertTree(tmp);
  return root;
}
```

### TypeScript

```typescript
function invertTree(root: TreeNode | null): TreeNode | null {
  if (!root) return null;
  const tmp = root.left;
  root.left = invertTree(root.right);
  root.right = invertTree(tmp);
  return root;
}
```

---

## P3: Same tree

### Approach

Compare two nodes: both null → true; one null → false; values differ → false; else same iff left pairs and right pairs match recursively. Iterative: stack/queue of pairs.

### Complexity

- Time: O(n)
- Space: O(h)

### Edge cases

- Both empty → true
- Same values, different structure → false
- Mirror images (left/right swapped) → false for “same tree”
- Early mismatch — short-circuit saves work

### Mobile note

Useful when snapshot-testing a small logical tree (nav state, form section tree) rather than full UI pixels.

### Kotlin

```kotlin
fun isSameTree(p: TreeNode?, q: TreeNode?): Boolean {
    if (p == null && q == null) return true
    if (p == null || q == null) return false
    if (p.value != q.value) return false
    return isSameTree(p.left, q.left) && isSameTree(p.right, q.right)
}
```

### Swift

```swift
func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
    if p == nil && q == nil { return true }
    guard let p, let q, p.val == q.val else { return false }
    return isSameTree(p.left, q.left) && isSameTree(p.right, q.right)
}
```

### Dart

```dart
bool isSameTree(TreeNode? p, TreeNode? q) {
  if (p == null && q == null) return true;
  if (p == null || q == null) return false;
  if (p.value != q.value) return false;
  return isSameTree(p.left, q.left) && isSameTree(p.right, q.right);
}
```

### TypeScript

```typescript
function isSameTree(p: TreeNode | null, q: TreeNode | null): boolean {
  if (!p && !q) return true;
  if (!p || !q || p.val !== q.val) return false;
  return isSameTree(p.left, q.left) && isSameTree(p.right, q.right);
}
```
