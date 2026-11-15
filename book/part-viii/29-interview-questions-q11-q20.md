# Chapter 29 — Interview Questions, Mobile-Dev Focused — Q11–Q20

Part of [Chapter 29 — Interview Questions, Mobile-Dev Focused](29-interview-questions.md). Read the overview first for the timing rules and strategy.

---

## Q11. Linked List Cycle (Floyd)

**Topic:** Linked lists

**Statement**

Detect whether a list has a cycle. Framing: corrupted listener chain / retain-cycle analog in a node graph.

**Approach**

Slow/fast pointers; meet ⇒ cycle. O(1) extra memory.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun hasCycle(head: ListNode?): Boolean {
    var slow = head
    var fast = head
    while (fast?.next != null) {
        slow = slow!!.next
        fast = fast.next!!.next
        if (slow === fast) return true
    }
    return false
}
```

### Swift

```swift
func hasCycle(_ head: ListNode?) -> Bool {
    var slow = head, fast = head
    while let f = fast?.next {
        slow = slow?.next
        fast = f.next
        if slow === fast { return true }
    }
    return false
}
```

### Dart

```dart
bool hasCycle(ListNode? head) {
  var slow = head, fast = head;
  while (fast?.next != null) {
    slow = slow!.next;
    fast = fast!.next!.next;
    if (identical(slow, fast)) return true;
  }
  return false;
}
```

### TypeScript

```typescript
function hasCycle(head: ListNode | null): boolean {
  let slow = head, fast = head;
  while (fast?.next) {
    slow = slow!.next;
    fast = fast.next.next;
    if (slow === fast) return true;
  }
  return false;
}
```

## Q12. Merge Two Sorted Lists

**Topic:** Linked lists

**Statement**

Merge two sorted lists into one sorted list. Framing: merge two sorted local change logs.

**Approach**

Dummy head; always take smaller node.

**Complexity:** Time O(n+m), Space O(1) aside from links

### Kotlin

```kotlin
fun mergeTwoLists(a: ListNode?, b: ListNode?): ListNode? {
    val dummy = ListNode(0)
    var t = dummy
    var p = a; var q = b
    while (p != null && q != null) {
        if (p.`val` <= q.`val`) { t.next = p; p = p.next }
        else { t.next = q; q = q.next }
        t = t.next!!
    }
    t.next = p ?: q
    return dummy.next
}
```

### Swift

```swift
func mergeTwoLists(_ a: ListNode?, _ b: ListNode?) -> ListNode? {
    let dummy = ListNode(0); var t = dummy
    var p = a, q = b
    while let x = p, let y = q {
        if x.val <= y.val { t.next = x; p = x.next }
        else { t.next = y; q = y.next }
        t = t.next!
    }
    t.next = p ?? q
    return dummy.next
}
```

### Dart

```dart
ListNode? mergeTwoLists(ListNode? a, ListNode? b) {
  final dummy = ListNode(0);
  var t = dummy;
  var p = a, q = b;
  while (p != null && q != null) {
    if (p.val <= q.val) { t.next = p; p = p.next; }
    else { t.next = q; q = q.next; }
    t = t.next!;
  }
  t.next = p ?? q;
  return dummy.next;
}
```

### TypeScript

```typescript
function mergeTwoLists(a: ListNode | null, b: ListNode | null): ListNode | null {
  const dummy = new ListNode(0);
  let t = dummy, p = a, q = b;
  while (p && q) {
    if (p.val <= q.val) { t.next = p; p = p.next; }
    else { t.next = q; q = q.next; }
    t = t.next!;
  }
  t.next = p ?? q;
  return dummy.next;
}
```

## Q13. Maximum Depth of Binary Tree

**Topic:** Trees

**Statement**

Return max depth of a binary tree. Framing: deepest nested JSON / view subtree.

**Approach**

DFS: `1 + max(left, right)`; or BFS levels.

**Complexity:** Time O(n), Space O(h)

### Kotlin

```kotlin
class TreeNode(var `val`: Int, var left: TreeNode? = null, var right: TreeNode? = null)
fun maxDepth(root: TreeNode?): Int =
    if (root == null) 0 else 1 + maxOf(maxDepth(root.left), maxDepth(root.right))
```

### Swift

```swift
class TreeNode {
    var val: Int; var left: TreeNode?; var right: TreeNode?
    init(_ val: Int) { self.val = val }
}
func maxDepth(_ root: TreeNode?) -> Int {
    guard let r = root else { return 0 }
    return 1 + max(maxDepth(r.left), maxDepth(r.right))
}
```

### Dart

```dart
class TreeNode {
  int val; TreeNode? left, right;
  TreeNode(this.val, [this.left, this.right]);
}
int maxDepth(TreeNode? root) {
  if (root == null) return 0;
  final l = maxDepth(root.left), r = maxDepth(root.right);
  return 1 + (l > r ? l : r);
}
```

### TypeScript

```typescript
class TreeNode {
  val: number; left: TreeNode | null; right: TreeNode | null;
  constructor(val = 0, left: TreeNode | null = null, right: TreeNode | null = null) {
    this.val = val; this.left = left; this.right = right;
  }
}
function maxDepth(root: TreeNode | null): number {
  if (!root) return 0;
  return 1 + Math.max(maxDepth(root.left), maxDepth(root.right));
}
```

## Q14. Invert Binary Tree

**Topic:** Trees

**Statement**

Swap every left/right child. Framing: RTL layout mirror of a settings tree.

**Approach**

DFS/BFS swap children at each node.

**Complexity:** Time O(n), Space O(h)

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
    guard let r = root else { return nil }
    let tmp = r.left
    r.left = invertTree(r.right)
    r.right = invertTree(tmp)
    return r
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

## Q15. Validate BST

**Topic:** Trees

**Statement**

Check whether a binary tree is a valid BST. Framing: validate an in-memory ordered index.

**Approach**

DFS with `(low, high)` bounds tightened along the path.

**Complexity:** Time O(n), Space O(h)

### Kotlin

```kotlin
fun isValidBST(root: TreeNode?): Boolean {
    fun go(n: TreeNode?, lo: Long, hi: Long): Boolean {
        if (n == null) return true
        val v = n.`val`.toLong()
        if (v <= lo || v >= hi) return false
        return go(n.left, lo, v) && go(n.right, v, hi)
    }
    return go(root, Long.MIN_VALUE, Long.MAX_VALUE)
}
```

### Swift

```swift
func isValidBST(_ root: TreeNode?) -> Bool {
    func go(_ n: TreeNode?, _ lo: Int?, _ hi: Int?) -> Bool {
        guard let n else { return true }
        if let lo, n.val <= lo { return false }
        if let hi, n.val >= hi { return false }
        return go(n.left, lo, n.val) && go(n.right, n.val, hi)
    }
    return go(root, nil, nil)
}
```

### Dart

```dart
bool isValidBST(TreeNode? root) {
  bool go(TreeNode? n, int? lo, int? hi) {
    if (n == null) return true;
    if (lo != null && n.val <= lo) return false;
    if (hi != null && n.val >= hi) return false;
    return go(n.left, lo, n.val) && go(n.right, n.val, hi);
  }
  return go(root, null, null);
}
```

### TypeScript

```typescript
function isValidBST(root: TreeNode | null): boolean {
  function go(n: TreeNode | null, lo: number | null, hi: number | null): boolean {
    if (!n) return true;
    if (lo !== null && n.val <= lo) return false;
    if (hi !== null && n.val >= hi) return false;
    return go(n.left, lo, n.val) && go(n.right, n.val, hi);
  }
  return go(root, null, null);
}
```

## Q16. Binary Tree Level Order

**Topic:** Trees

**Statement**

Return values level by level. Framing: render org-chart rows / comment threads by depth.

**Approach**

BFS queue; for each level size, drain that many nodes.

**Complexity:** Time O(n), Space O(n)

### Kotlin

```kotlin
fun levelOrder(root: TreeNode?): List<List<Int>> {
    if (root == null) return emptyList()
    val q = ArrayDeque<TreeNode>()
    q.add(root)
    val out = mutableListOf<List<Int>>()
    while (q.isNotEmpty()) {
        val level = mutableListOf<Int>()
        repeat(q.size) {
            val n = q.removeFirst()
            level.add(n.`val`)
            n.left?.let(q::add)
            n.right?.let(q::add)
        }
        out.add(level)
    }
    return out
}
```

### Swift

```swift
func levelOrder(_ root: TreeNode?) -> [[Int]] {
    guard let root else { return [] }
    var q: [TreeNode] = [root], out: [[Int]] = []
    var head = 0
    while head < q.count {
        var level: [Int] = []
        let count = q.count - head
        for _ in 0..<count {
            let n = q[head]; head += 1
            level.append(n.val)
            if let l = n.left { q.append(l) }
            if let r = n.right { q.append(r) }
        }
        out.append(level)
    }
    return out
}
```

### Dart

```dart
List<List<int>> levelOrder(TreeNode? root) {
  if (root == null) return [];
  final q = <TreeNode>[root];
  final out = <List<int>>[];
  var head = 0;
  while (head < q.length) {
    final level = <int>[];
    final count = q.length - head;
    for (var i = 0; i < count; i++) {
      final n = q[head++];
      level.add(n.val);
      if (n.left != null) q.add(n.left!);
      if (n.right != null) q.add(n.right!);
    }
    out.add(level);
  }
  return out;
}
```

### TypeScript

```typescript
function levelOrder(root: TreeNode | null): number[][] {
  if (!root) return [];
  const q: TreeNode[] = [root];
  const out: number[][] = [];
  let head = 0;
  while (head < q.length) {
    const size = q.length - head;
    const level: number[] = [];
    for (let i = 0; i < size; i++) {
      const n = q[head++];
      level.push(n.val);
      if (n.left) q.push(n.left);
      if (n.right) q.push(n.right);
    }
    out.push(level);
  }
  return out;
}
```

## Q17. Lowest Common Ancestor of BST

**Topic:** Trees

**Statement**

Find LCA of two nodes in a BST. Framing: common ancestor screen in a settings hierarchy keyed by ordered ids.

**Approach**

Walk from root: if both < node go left; both > go right; else node is LCA.

**Complexity:** Time O(h), Space O(1) iterative

### Kotlin

```kotlin
fun lowestCommonAncestor(root: TreeNode?, p: TreeNode?, q: TreeNode?): TreeNode? {
    var cur = root
    val a = p!!.`val`; val b = q!!.`val`
    while (cur != null) {
        cur = when {
            a < cur.`val` && b < cur.`val` -> cur.left
            a > cur.`val` && b > cur.`val` -> cur.right
            else -> return cur
        }
    }
    return null
}
```

### Swift

```swift
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
```

### Dart

```dart
TreeNode? lowestCommonAncestor(TreeNode? root, TreeNode? p, TreeNode? q) {
  var cur = root;
  final a = p!.val, b = q!.val;
  while (cur != null) {
    if (a < cur.val && b < cur.val) cur = cur.left;
    else if (a > cur.val && b > cur.val) cur = cur.right;
    else return cur;
  }
  return null;
}
```

### TypeScript

```typescript
function lowestCommonAncestor(root: TreeNode | null, p: TreeNode | null, q: TreeNode | null): TreeNode | null {
  let cur = root;
  const a = p!.val, b = q!.val;
  while (cur) {
    if (a < cur.val && b < cur.val) cur = cur.left;
    else if (a > cur.val && b > cur.val) cur = cur.right;
    else return cur;
  }
  return null;
}
```

## Q18. Binary Search

**Topic:** Binary search

**Statement**

Find index of `target` in sorted `nums`, or -1. Framing: jump to a transcript timestamp in a sorted cue list.

**Approach**

Classic mid compare; watch overflow-safe mid.

**Complexity:** Time O(log n), Space O(1)

### Kotlin

```kotlin
fun search(nums: IntArray, target: Int): Int {
    var lo = 0; var hi = nums.lastIndex
    while (lo <= hi) {
        val mid = (lo + hi) ushr 1
        when {
            nums[mid] == target -> return mid
            nums[mid] < target -> lo = mid + 1
            else -> hi = mid - 1
        }
    }
    return -1
}
```

### Swift

```swift
func search(_ nums: [Int], _ target: Int) -> Int {
    var lo = 0, hi = nums.count - 1
    while lo <= hi {
        let mid = (lo + hi) / 2
        if nums[mid] == target { return mid }
        if nums[mid] < target { lo = mid + 1 } else { hi = mid - 1 }
    }
    return -1
}
```

### Dart

```dart
int search(List<int> nums, int target) {
  var lo = 0, hi = nums.length - 1;
  while (lo <= hi) {
    final mid = (lo + hi) >> 1;
    if (nums[mid] == target) return mid;
    if (nums[mid] < target) lo = mid + 1; else hi = mid - 1;
  }
  return -1;
}
```

### TypeScript

```typescript
function search(nums: number[], target: number): number {
  let lo = 0, hi = nums.length - 1;
  while (lo <= hi) {
    const mid = (lo + hi) >> 1;
    if (nums[mid] === target) return mid;
    if (nums[mid] < target) lo = mid + 1; else hi = mid - 1;
  }
  return -1;
}
```

## Q19. Search Insert Position (Lower Bound)

**Topic:** Binary search

**Statement**

Return index where `target` is or should be inserted in sorted array. Framing: insert a message into a timestamp-sorted buffer.

**Approach**

Lower bound binary search — first index with `nums[i] >= target`.

**Complexity:** Time O(log n), Space O(1)

### Kotlin

```kotlin
fun searchInsert(nums: IntArray, target: Int): Int {
    var lo = 0; var hi = nums.size
    while (lo < hi) {
        val mid = (lo + hi) ushr 1
        if (nums[mid] < target) lo = mid + 1 else hi = mid
    }
    return lo
}
```

### Swift

```swift
func searchInsert(_ nums: [Int], _ target: Int) -> Int {
    var lo = 0, hi = nums.count
    while lo < hi {
        let mid = (lo + hi) / 2
        if nums[mid] < target { lo = mid + 1 } else { hi = mid }
    }
    return lo
}
```

### Dart

```dart
int searchInsert(List<int> nums, int target) {
  var lo = 0, hi = nums.length;
  while (lo < hi) {
    final mid = (lo + hi) >> 1;
    if (nums[mid] < target) lo = mid + 1; else hi = mid;
  }
  return lo;
}
```

### TypeScript

```typescript
function searchInsert(nums: number[], target: number): number {
  let lo = 0, hi = nums.length;
  while (lo < hi) {
    const mid = (lo + hi) >> 1;
    if (nums[mid] < target) lo = mid + 1; else hi = mid;
  }
  return lo;
}
```

## Q20. Find Peak Element

**Topic:** Binary search

**Statement**

A peak is greater than neighbors; return any peak index. Framing: find a local maximum in a sampled battery/CPU series (unsorted).

**Approach**

Binary search on slope: if `mid < mid+1` climb right, else left. Ends are peaks if descending inward.

**Complexity:** Time O(log n), Space O(1)

### Kotlin

```kotlin
fun findPeakElement(nums: IntArray): Int {
    var lo = 0; var hi = nums.lastIndex
    while (lo < hi) {
        val mid = (lo + hi) ushr 1
        if (nums[mid] < nums[mid + 1]) lo = mid + 1 else hi = mid
    }
    return lo
}
```

### Swift

```swift
func findPeakElement(_ nums: [Int]) -> Int {
    var lo = 0, hi = nums.count - 1
    while lo < hi {
        let mid = (lo + hi) / 2
        if nums[mid] < nums[mid + 1] { lo = mid + 1 } else { hi = mid }
    }
    return lo
}
```

### Dart

```dart
int findPeakElement(List<int> nums) {
  var lo = 0, hi = nums.length - 1;
  while (lo < hi) {
    final mid = (lo + hi) >> 1;
    if (nums[mid] < nums[mid + 1]) lo = mid + 1; else hi = mid;
  }
  return lo;
}
```

### TypeScript

```typescript
function findPeakElement(nums: number[]): number {
  let lo = 0, hi = nums.length - 1;
  while (lo < hi) {
    const mid = (lo + hi) >> 1;
    if (nums[mid] < nums[mid + 1]) lo = mid + 1; else hi = mid;
  }
  return lo;
}
```

---

Previous: [Chapter 29 — Interview Questions, Mobile-Dev Focused — Q1–Q10](29-interview-questions-q01-q10.md) · Next: [Chapter 29 — Interview Questions, Mobile-Dev Focused — Q21–Q30](29-interview-questions-q21-q30.md) · Solutions: [`solutions/ch29`](../../solutions/ch29/README.md)
