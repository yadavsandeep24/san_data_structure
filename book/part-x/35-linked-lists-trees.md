# Chapter 35 — Linked Lists & Trees (12-Day Plan Gap-Closer)

Part X fills the gaps between the book and the public **12-day DSA plan** (120 standard LeetCode problems). This chapter covers the plan's linked-list and binary-tree problems that the book did not have yet. The plan problems already in the book stay where they are, mostly in the Chapter 24 question bank: [Reverse Linked List (Ch 24 Q10)](../part-vii/24-interview-questions.md#q10-reverse-linked-list), [Linked List Cycle (Ch 24 Q11)](../part-vii/24-interview-questions.md#q11-linked-list-cycle-floyd), [Merge Two Sorted Lists (Ch 24 Q12)](../part-vii/24-interview-questions.md#q12-merge-two-sorted-lists), [Maximum Depth (Ch 24 Q13)](../part-vii/24-interview-questions.md#q13-maximum-depth-of-binary-tree), [Invert Binary Tree (Ch 24 Q14)](../part-vii/24-interview-questions.md#q14-invert-binary-tree), [Validate BST (Ch 24 Q15)](../part-vii/24-interview-questions.md#q15-validate-bst), [Level Order (Ch 24 Q16)](../part-vii/24-interview-questions.md#q16-binary-tree-level-order), [LCA of a BST (Ch 24 Q17)](../part-vii/24-interview-questions.md#q17-lowest-common-ancestor-of-bst), [Merge K Sorted Lists (Ch 24 Q26)](../part-vii/24-interview-questions.md#q26-merge-k-sorted-lists-feed-merge) and [LRU Cache (Ch 24 Q36)](../part-vii/24-interview-questions.md#q36-lru-cache). Same Tree is in [`solutions/ch09`](../../solutions/ch09/README.md#p3-same-tree); topic background is in [Chapter 04](../part-ii/04-linked-lists.md), [Chapter 09](../part-iii/09-trees-basics.md) and [Chapter 10](../part-iii/10-trees-practical.md); Serialize/Deserialize and Max Path Sum are in the [Chapter 27 hard bank](../part-viii/27-hard-drill-bank.md).

Companion index: [`solutions/ch35/README.md`](../../solutions/ch35/README.md)

---

## How to use

| Protocol | Detail |
|----------|--------|
| **Time** | 15–30 minutes per problem (Q5–Q7 are easy, the rest medium) |
| **Speak first** | Brute force in one sentence, then the optimal idea and **time/space before code** |
| **Languages** | Every entry shows **Kotlin, Swift, Dart, TypeScript** in that order (Android/KMP, iOS, Flutter, React Native). Dart snippets that call `max` need `import 'dart:math';` |
| **Mobile tell** | One sentence where it helps: main-thread cost, memory bound, or the UI tree it maps to |
| **Plan Day 6** | Q1 Reorder List, Q2 Remove Nth Node From End, Q3 Copy List with Random Pointer, Q4 Add Two Numbers |
| **Plan Day 7** | Q5 Diameter, Q6 Balanced Binary Tree, Q7 Subtree of Another Tree |
| **Plan Day 8** | Q8 Right Side View, Q9 Count Good Nodes, Q10 Kth Smallest in a BST, Q11 Construct from Preorder + Inorder |

**Order to drill:** Q1 uses three Chapter 04 moves (middle, reverse, merge), so do it after Q2. Q5, Q6 and Q9 are the same post-order or pre-order DFS template with a different return value.

---

## Shared node classes

Every entry below uses these two classes (same shape as Chapter 24 and Chapter 27). Q3 defines its own `Node` because it needs a `random` field.

### Kotlin

```kotlin
class ListNode(var `val`: Int, var next: ListNode? = null)

class TreeNode(var `val`: Int) {
    var left: TreeNode? = null
    var right: TreeNode? = null
}
```

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

### TypeScript

```typescript
class ListNode {
  val: number;
  next: ListNode | null;
  constructor(val = 0, next: ListNode | null = null) { this.val = val; this.next = next; }
}

class TreeNode {
  val: number;
  left: TreeNode | null = null;
  right: TreeNode | null = null;
  constructor(val = 0) { this.val = val; }
}
```

---

## Q1. Reorder List (Interleave Oldest and Newest)

**Topic:** Linked list (middle, reverse, merge)

**Plan day:** Day 6

**Statement**

Rearrange a singly linked list `L0 → L1 → … → Ln` in place into `L0 → Ln → L1 → Ln-1 → L2 → …`, for example to alternate the oldest and newest items in a feed. Change links, not values.

**Approach**

Brute force: copy nodes into an array and relink with two indices, O(n) extra space. Optimal: find the middle with slow/fast pointers, reverse the second half in place, then weave the two halves together.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun reorderList(head: ListNode?) {
    if (head?.next == null) return
    // 1. Find the middle (slow ends at the end of the first half).
    var slow: ListNode = head
    var fast: ListNode? = head
    while (fast?.next?.next != null) {
        slow = slow.next!!
        fast = fast.next!!.next
    }
    // 2. Reverse the second half.
    var prev: ListNode? = null
    var cur = slow.next
    slow.next = null
    while (cur != null) {
        val nxt = cur.next
        cur.next = prev
        prev = cur
        cur = nxt
    }
    // 3. Weave: first, last, second, second-last, ...
    var a: ListNode? = head
    var b = prev
    while (a != null && b != null) {
        val aNext = a.next
        val bNext = b.next
        a.next = b
        b.next = aNext
        a = aNext
        b = bNext
    }
}
```

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

### TypeScript

```typescript
function reorderList(head: ListNode | null): void {
  if (!head || !head.next) return;
  // 1. Find the middle (slow ends at the end of the first half).
  let slow: ListNode = head;
  let fast: ListNode | null = head;
  while (fast && fast.next && fast.next.next) {
    slow = slow.next!;
    fast = fast.next.next;
  }
  // 2. Reverse the second half.
  let prev: ListNode | null = null;
  let cur = slow.next;
  slow.next = null;
  while (cur) {
    const nxt: ListNode | null = cur.next;
    cur.next = prev;
    prev = cur;
    cur = nxt;
  }
  // 3. Weave: first, last, second, second-last, ...
  let a: ListNode | null = head;
  let b: ListNode | null = prev;
  while (a && b) {
    const aNext: ListNode | null = a.next;
    const bNext: ListNode | null = b.next;
    a.next = b;
    b.next = aNext;
    a = aNext;
    b = bNext;
  }
}
```

---

## Q2. Remove Nth Node From End of List (Drop the Nth-Latest Notification)

**Topic:** Linked list (two pointers)

**Plan day:** Day 6

**Statement**

Given the head of a list and `n` (1 ≤ n ≤ length), remove the `n`-th node counted from the end and return the head, in a single pass.

**Approach**

Brute force: count the length, then walk `length - n` steps, which takes two passes. Optimal: a dummy node before the head, then move `lead` `n + 1` steps ahead of `trail`; advance both until `lead` falls off, and `trail` is now just before the node to unlink. The dummy handles removing the head.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun removeNthFromEnd(head: ListNode?, n: Int): ListNode? {
    val dummy = ListNode(0, head)
    var lead: ListNode? = dummy
    repeat(n + 1) { lead = lead?.next } // open a gap of n nodes
    var trail: ListNode = dummy
    while (lead != null) {
        lead = lead?.next
        trail = trail.next!!
    }
    trail.next = trail.next?.next // trail sits just before the target
    return dummy.next
}
```

### Swift

```swift
func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
    let dummy = ListNode(0, head)
    var lead: ListNode? = dummy
    for _ in 0...n { lead = lead?.next } // open a gap of n nodes
    var trail = dummy
    while lead != nil {
        lead = lead?.next
        guard let nxt = trail.next else { break }
        trail = nxt
    }
    trail.next = trail.next?.next // trail sits just before the target
    return dummy.next
}
```

### Dart

```dart
ListNode? removeNthFromEnd(ListNode? head, int n) {
  final dummy = ListNode(0, head);
  ListNode? lead = dummy;
  for (var i = 0; i <= n; i++) lead = lead?.next; // open a gap of n nodes
  var trail = dummy;
  while (lead != null) {
    lead = lead.next;
    trail = trail.next!;
  }
  trail.next = trail.next?.next; // trail sits just before the target
  return dummy.next;
}
```

### TypeScript

```typescript
function removeNthFromEnd(head: ListNode | null, n: number): ListNode | null {
  const dummy = new ListNode(0, head);
  let lead: ListNode | null = dummy;
  for (let i = 0; i <= n; i++) lead = lead!.next; // open a gap of n nodes
  let trail: ListNode = dummy;
  while (lead) {
    lead = lead.next;
    trail = trail.next!;
  }
  trail.next = trail.next!.next; // trail sits just before the target
  return dummy.next;
}
```

---

## Q3. Copy List with Random Pointer (Deep Copy a Linked Playlist)

**Topic:** Linked list + hash map

**Plan day:** Day 6

**Statement**

Each node has `next` and a `random` pointer to any node in the list or `null` (say, a "jump to related track" link). Return a deep copy: brand-new nodes with the same values whose `next` and `random` point into the copy, never into the original.

**Approach**

Brute force: for each node find its `random` target's position by walking from the head, O(n²). Optimal: pass 1 clones every node into an `original → copy` map; pass 2 wires `copy.next` and `copy.random` through the map. (Follow-up: interleave copies inside the original list to get O(1) extra space.)

**Complexity:** Time O(n), Space O(n)

### Kotlin

```kotlin
class Node(var `val`: Int) {
    var next: Node? = null
    var random: Node? = null
}

fun copyRandomList(head: Node?): Node? {
    val copies = HashMap<Node, Node>()
    var cur = head
    while (cur != null) { // pass 1: clone every node
        copies[cur] = Node(cur.`val`)
        cur = cur.next
    }
    cur = head
    while (cur != null) { // pass 2: wire next + random through the map
        val copy = copies.getValue(cur)
        copy.next = cur.next?.let { copies.getValue(it) }
        copy.random = cur.random?.let { copies.getValue(it) }
        cur = cur.next
    }
    return head?.let { copies.getValue(it) }
}
```

### Swift

```swift
final class Node {
    var val: Int
    var next: Node?
    var random: Node?
    init(_ val: Int) { self.val = val }
}

func copyRandomList(_ head: Node?) -> Node? {
    var copies: [ObjectIdentifier: Node] = [:] // keyed by original node identity
    var cur = head
    while let c = cur { // pass 1: clone every node
        copies[ObjectIdentifier(c)] = Node(c.val)
        cur = c.next
    }
    cur = head
    while let c = cur { // pass 2: wire next + random through the map
        let copy = copies[ObjectIdentifier(c)]
        copy?.next = c.next.flatMap { copies[ObjectIdentifier($0)] }
        copy?.random = c.random.flatMap { copies[ObjectIdentifier($0)] }
        cur = c.next
    }
    return head.flatMap { copies[ObjectIdentifier($0)] }
}
```

### Dart

```dart
class Node {
  int val;
  Node? next;
  Node? random;
  Node(this.val);
}

Node? copyRandomList(Node? head) {
  final copies = Map<Node, Node>.identity();
  for (var cur = head; cur != null; cur = cur.next) {
    copies[cur] = Node(cur.val); // pass 1: clone every node
  }
  for (var cur = head; cur != null; cur = cur.next) { // pass 2: wire next + random
    final copy = copies[cur]!;
    copy.next = cur.next == null ? null : copies[cur.next!];
    copy.random = cur.random == null ? null : copies[cur.random!];
  }
  return head == null ? null : copies[head];
}
```

### TypeScript

```typescript
class Node {
  val: number;
  next: Node | null = null;
  random: Node | null = null;
  constructor(val: number) { this.val = val; }
}

function copyRandomList(head: Node | null): Node | null {
  const copies = new Map<Node, Node>();
  for (let cur = head; cur; cur = cur.next) copies.set(cur, new Node(cur.val)); // pass 1: clone
  for (let cur = head; cur; cur = cur.next) { // pass 2: wire next + random through the map
    const copy = copies.get(cur)!;
    copy.next = cur.next ? copies.get(cur.next)! : null;
    copy.random = cur.random ? copies.get(cur.random)! : null;
  }
  return head ? copies.get(head)! : null;
}
```

**Mobile note:** This is the classic reason to deep-copy before handing state to another screen or thread: a shallow copy would share `random` targets with the original.

---

## Q4. Add Two Numbers (Digit-List Amount Sum)

**Topic:** Linked list (carry)

**Plan day:** Day 6

**Statement**

Two non-negative integers are stored as linked lists of digits in reverse order (ones digit first), e.g. `342` is `2 → 4 → 3`. Return their sum in the same format. The numbers may be longer than any built-in integer type.

**Approach**

Brute force: convert to numbers, add, convert back, which overflows on long inputs. Optimal: walk both lists together like column addition, summing the digits plus `carry`, emitting `sum % 10` and carrying `sum / 10`. Keep looping while either list or the carry remains.

**Complexity:** Time O(max(m, n)), Space O(max(m, n)) for the output

### Kotlin

```kotlin
fun addTwoNumbers(l1: ListNode?, l2: ListNode?): ListNode? {
    val dummy = ListNode(0)
    var tail = dummy
    var a = l1
    var b = l2
    var carry = 0
    while (a != null || b != null || carry != 0) {
        val sum = (a?.`val` ?: 0) + (b?.`val` ?: 0) + carry
        carry = sum / 10
        tail.next = ListNode(sum % 10)
        tail = tail.next!!
        a = a?.next
        b = b?.next
    }
    return dummy.next
}
```

### Swift

```swift
func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    let dummy = ListNode(0)
    var tail = dummy
    var a = l1, b = l2
    var carry = 0
    while a != nil || b != nil || carry != 0 {
        let sum = (a?.val ?? 0) + (b?.val ?? 0) + carry
        carry = sum / 10
        let node = ListNode(sum % 10)
        tail.next = node
        tail = node
        a = a?.next
        b = b?.next
    }
    return dummy.next
}
```

### Dart

```dart
ListNode? addTwoNumbers(ListNode? l1, ListNode? l2) {
  final dummy = ListNode(0);
  var tail = dummy;
  var a = l1, b = l2;
  var carry = 0;
  while (a != null || b != null || carry != 0) {
    final sum = (a?.val ?? 0) + (b?.val ?? 0) + carry;
    carry = sum ~/ 10;
    final node = ListNode(sum % 10);
    tail.next = node;
    tail = node;
    a = a?.next;
    b = b?.next;
  }
  return dummy.next;
}
```

### TypeScript

```typescript
function addTwoNumbers(l1: ListNode | null, l2: ListNode | null): ListNode | null {
  const dummy = new ListNode(0);
  let tail = dummy;
  let carry = 0;
  while (l1 || l2 || carry) {
    const sum = (l1 ? l1.val : 0) + (l2 ? l2.val : 0) + carry;
    carry = Math.floor(sum / 10);
    tail.next = new ListNode(sum % 10);
    tail = tail.next;
    l1 = l1 ? l1.next : null;
    l2 = l2 ? l2.next : null;
  }
  return dummy.next;
}
```

**Mobile note:** Arbitrary-precision addition is what `BigDecimal` / `BigInt` do internally; in a payments app you use those (or integer minor units) rather than hand-rolled digit lists, but the carry loop is the same.

---

## Q5. Diameter of Binary Tree (Longest Path in a View Tree)

**Topic:** Tree DFS (post-order)

**Plan day:** Day 7

**Statement**

Return the number of edges on the longest path between any two nodes of a binary tree. The path need not pass through the root.

**Approach**

Brute force: for every node compute the left and right heights separately, O(n²) on a skewed tree. Optimal: one post-order pass where `height(node)` returns `1 + max(l, r)` and, as a side effect, updates `best = max(best, l + r)`, which is the longest path that bends at that node.

**Complexity:** Time O(n), Space O(h) recursion

### Kotlin

```kotlin
fun diameterOfBinaryTree(root: TreeNode?): Int {
    var best = 0
    fun height(node: TreeNode?): Int { // nodes on the longest downward path
        if (node == null) return 0
        val l = height(node.left)
        val r = height(node.right)
        best = maxOf(best, l + r) // longest path bending at this node
        return 1 + maxOf(l, r)
    }
    height(root)
    return best
}
```

### Swift

```swift
func diameterOfBinaryTree(_ root: TreeNode?) -> Int {
    var best = 0
    func height(_ node: TreeNode?) -> Int { // nodes on the longest downward path
        guard let node = node else { return 0 }
        let l = height(node.left)
        let r = height(node.right)
        best = max(best, l + r) // longest path bending at this node
        return 1 + max(l, r)
    }
    _ = height(root)
    return best
}
```

### Dart

```dart
int diameterOfBinaryTree(TreeNode? root) {
  var best = 0;
  int height(TreeNode? node) { // nodes on the longest downward path
    if (node == null) return 0;
    final l = height(node.left);
    final r = height(node.right);
    best = max(best, l + r); // longest path bending at this node
    return 1 + max(l, r);
  }
  height(root);
  return best;
}
```

### TypeScript

```typescript
function diameterOfBinaryTree(root: TreeNode | null): number {
  let best = 0;
  const height = (node: TreeNode | null): number => { // nodes on the longest downward path
    if (!node) return 0;
    const l = height(node.left);
    const r = height(node.right);
    best = Math.max(best, l + r); // longest path bending at this node
    return 1 + Math.max(l, r);
  };
  height(root);
  return best;
}
```

**Mobile note:** On Android the deepest View hierarchy or Compose composition branch is what drives measure and layout cost. Deep recursion on a huge or skewed tree can overflow the stack, so production tools walk iteratively.

---

## Q6. Balanced Binary Tree (Layout Depth Check)

**Topic:** Tree DFS (post-order)

**Plan day:** Day 7

**Statement**

Return whether a binary tree is height-balanced: at every node the heights of the left and right subtrees differ by at most 1.

**Approach**

Brute force: call a separate `height()` at every node, O(n²) worst case. Optimal: compute heights bottom-up and return a sentinel `-1` as soon as any subtree is unbalanced, so the whole check is one pass that exits early.

**Complexity:** Time O(n), Space O(h)

### Kotlin

```kotlin
fun isBalanced(root: TreeNode?): Boolean {
    fun height(node: TreeNode?): Int { // -1 means "already unbalanced"
        if (node == null) return 0
        val l = height(node.left)
        if (l == -1) return -1
        val r = height(node.right)
        if (r == -1 || kotlin.math.abs(l - r) > 1) return -1
        return 1 + maxOf(l, r)
    }
    return height(root) != -1
}
```

### Swift

```swift
func isBalanced(_ root: TreeNode?) -> Bool {
    func height(_ node: TreeNode?) -> Int { // -1 means "already unbalanced"
        guard let node = node else { return 0 }
        let l = height(node.left)
        if l == -1 { return -1 }
        let r = height(node.right)
        if r == -1 || abs(l - r) > 1 { return -1 }
        return 1 + max(l, r)
    }
    return height(root) != -1
}
```

### Dart

```dart
bool isBalanced(TreeNode? root) {
  int height(TreeNode? node) { // -1 means "already unbalanced"
    if (node == null) return 0;
    final l = height(node.left);
    if (l == -1) return -1;
    final r = height(node.right);
    if (r == -1 || (l - r).abs() > 1) return -1;
    return 1 + max(l, r);
  }
  return height(root) != -1;
}
```

### TypeScript

```typescript
function isBalanced(root: TreeNode | null): boolean {
  const height = (node: TreeNode | null): number => { // -1 means "already unbalanced"
    if (!node) return 0;
    const l = height(node.left);
    if (l === -1) return -1;
    const r = height(node.right);
    if (r === -1 || Math.abs(l - r) > 1) return -1;
    return 1 + Math.max(l, r);
  };
  return height(root) !== -1;
}
```

**Mobile note:** The sentinel-return trick (one value carries both "height" and "failed") keeps the walk to one pass, the same way a lint check over a View tree or composition tree should report the first offender without re-walking subtrees.

---

## Q7. Subtree of Another Tree (Find a Component Pattern)

**Topic:** Tree recursion

**Plan day:** Day 7

**Statement**

Given trees `root` and `subRoot`, return whether `root` contains a subtree with exactly the same structure and values as `subRoot` (a node plus all of its descendants).

**Approach**

Brute force (the expected interview answer): at every node of `root` run a `sameTree` check against `subRoot`. Short-circuiting `||` stops at the first match. Follow-up: serialize both trees with null markers and use KMP or hashing to get O(m + n).

**Complexity:** Time O(m · n) worst case, Space O(h)

### Kotlin

```kotlin
fun isSubtree(root: TreeNode?, subRoot: TreeNode?): Boolean {
    fun same(a: TreeNode?, b: TreeNode?): Boolean =
        if (a == null || b == null) a === b
        else a.`val` == b.`val` && same(a.left, b.left) && same(a.right, b.right)

    if (subRoot == null) return true
    if (root == null) return false
    return same(root, subRoot) || isSubtree(root.left, subRoot) || isSubtree(root.right, subRoot)
}
```

### Swift

```swift
func isSubtree(_ root: TreeNode?, _ subRoot: TreeNode?) -> Bool {
    func same(_ a: TreeNode?, _ b: TreeNode?) -> Bool {
        guard let a = a, let b = b else { return a == nil && b == nil }
        return a.val == b.val && same(a.left, b.left) && same(a.right, b.right)
    }
    guard let subRoot = subRoot else { return true }
    guard let root = root else { return false }
    return same(root, subRoot) || isSubtree(root.left, subRoot) || isSubtree(root.right, subRoot)
}
```

### Dart

```dart
bool isSubtree(TreeNode? root, TreeNode? subRoot) {
  bool same(TreeNode? a, TreeNode? b) {
    if (a == null || b == null) return identical(a, b);
    return a.val == b.val && same(a.left, b.left) && same(a.right, b.right);
  }

  if (subRoot == null) return true;
  if (root == null) return false;
  return same(root, subRoot) || isSubtree(root.left, subRoot) || isSubtree(root.right, subRoot);
}
```

### TypeScript

```typescript
function isSubtree(root: TreeNode | null, subRoot: TreeNode | null): boolean {
  const same = (a: TreeNode | null, b: TreeNode | null): boolean =>
    !a || !b ? a === b : a.val === b.val && same(a.left, b.left) && same(a.right, b.right);

  if (!subRoot) return true;
  if (!root) return false;
  return same(root, subRoot) || isSubtree(root.left, subRoot) || isSubtree(root.right, subRoot);
}
```

**Mobile note:** This is the same question a UI test asks when it looks for a component subtree. Espresso matches against the View tree and Compose test finders match against the semantics tree, so structural matching is what both are doing.

---

## Q8. Binary Tree Right Side View (What the Right Edge Shows)

**Topic:** BFS level order

**Plan day:** Day 8

**Statement**

Imagine standing to the right of a binary tree. Return the values you can see from top to bottom, which is the last node of each level.

**Approach**

Brute force: collect every level fully into lists and then take each list's last element, which is the same O(n) but uses extra lists. Optimal: BFS level by level and record the last node of each level. (A DFS that visits right before left and records the first node at each new depth also works.)

**Complexity:** Time O(n), Space O(w) where w is the widest level

### Kotlin

```kotlin
fun rightSideView(root: TreeNode?): List<Int> {
    val out = mutableListOf<Int>()
    if (root == null) return out
    val q = ArrayDeque<TreeNode>()
    q.addLast(root)
    while (q.isNotEmpty()) {
        val size = q.size
        repeat(size) { i ->
            val n = q.removeFirst()
            if (i == size - 1) out += n.`val` // last node of this level
            n.left?.let { q.addLast(it) }
            n.right?.let { q.addLast(it) }
        }
    }
    return out
}
```

### Swift

```swift
func rightSideView(_ root: TreeNode?) -> [Int] {
    var out: [Int] = []
    guard let root = root else { return out }
    var level = [root]
    while let last = level.last {
        out.append(last.val) // last node of this level
        var next: [TreeNode] = []
        for n in level {
            if let l = n.left { next.append(l) }
            if let r = n.right { next.append(r) }
        }
        level = next
    }
    return out
}
```

### Dart

```dart
List<int> rightSideView(TreeNode? root) {
  final out = <int>[];
  if (root == null) return out;
  var level = [root];
  while (level.isNotEmpty) {
    out.add(level.last.val); // last node of this level
    final next = <TreeNode>[];
    for (final n in level) {
      if (n.left != null) next.add(n.left!);
      if (n.right != null) next.add(n.right!);
    }
    level = next;
  }
  return out;
}
```

### TypeScript

```typescript
function rightSideView(root: TreeNode | null): number[] {
  const out: number[] = [];
  if (!root) return out;
  let level: TreeNode[] = [root];
  while (level.length) {
    out.push(level[level.length - 1].val); // last node of this level
    const next: TreeNode[] = [];
    for (const n of level) {
      if (n.left) next.push(n.left);
      if (n.right) next.push(n.right);
    }
    level = next;
  }
  return out;
}
```

---

## Q9. Count Good Nodes in Binary Tree (Record-High Checkpoints)

**Topic:** Tree DFS with path state

**Plan day:** Day 8

**Statement**

A node is good if no node on the path from the root down to it has a greater value. Return the number of good nodes. Think of each root-to-leaf path as a balance history, where a good node is a new (or tied) high.

**Approach**

Brute force: for each node walk back up its path, O(n·h). Optimal: DFS passing down `maxSoFar`; a node is good when `val >= maxSoFar`, and its children receive `max(maxSoFar, val)`.

**Complexity:** Time O(n), Space O(h)

### Kotlin

```kotlin
fun goodNodes(root: TreeNode?): Int {
    fun dfs(node: TreeNode?, maxSoFar: Int): Int {
        if (node == null) return 0
        val good = if (node.`val` >= maxSoFar) 1 else 0
        val next = maxOf(maxSoFar, node.`val`)
        return good + dfs(node.left, next) + dfs(node.right, next)
    }
    return dfs(root, Int.MIN_VALUE)
}
```

### Swift

```swift
func goodNodes(_ root: TreeNode?) -> Int {
    func dfs(_ node: TreeNode?, _ maxSoFar: Int) -> Int {
        guard let node = node else { return 0 }
        let good = node.val >= maxSoFar ? 1 : 0
        let next = max(maxSoFar, node.val)
        return good + dfs(node.left, next) + dfs(node.right, next)
    }
    return dfs(root, Int.min)
}
```

### Dart

```dart
int goodNodes(TreeNode? root) {
  int dfs(TreeNode? node, int maxSoFar) {
    if (node == null) return 0;
    final good = node.val >= maxSoFar ? 1 : 0;
    final next = max(maxSoFar, node.val);
    return good + dfs(node.left, next) + dfs(node.right, next);
  }
  return root == null ? 0 : dfs(root, root.val); // the root is always good
}
```

### TypeScript

```typescript
function goodNodes(root: TreeNode | null): number {
  const dfs = (node: TreeNode | null, maxSoFar: number): number => {
    if (!node) return 0;
    const good = node.val >= maxSoFar ? 1 : 0;
    const next = Math.max(maxSoFar, node.val);
    return good + dfs(node.left, next) + dfs(node.right, next);
  };
  return dfs(root, -Infinity);
}
```

---

## Q10. Kth Smallest Element in a BST (Kth Cheapest in a Price Index)

**Topic:** BST in-order traversal

**Plan day:** Day 8

**Statement**

Given the root of a binary search tree and `k` (1-indexed), return the `k`-th smallest value.

**Approach**

Brute force: collect the full in-order list, then index `k - 1`, which is O(n) time and space. Optimal: an iterative in-order walk with an explicit stack that stops as soon as it has popped `k` nodes. That costs O(h + k) and never materializes the list.

**Complexity:** Time O(h + k), Space O(h)

### Kotlin

```kotlin
fun kthSmallest(root: TreeNode?, k: Int): Int {
    val stack = ArrayDeque<TreeNode>()
    var cur = root
    var count = 0
    while (cur != null || stack.isNotEmpty()) {
        while (cur != null) { // walk left as far as possible
            stack.addLast(cur)
            cur = cur.left
        }
        val node = stack.removeLast()
        if (++count == k) return node.`val` // in-order visits values ascending
        cur = node.right
    }
    throw IllegalArgumentException("k > number of nodes")
}
```

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

### TypeScript

```typescript
function kthSmallest(root: TreeNode | null, k: number): number {
  const stack: TreeNode[] = [];
  let cur = root;
  let count = 0;
  while (cur || stack.length) {
    while (cur) { // walk left as far as possible
      stack.push(cur);
      cur = cur.left;
    }
    const node = stack.pop()!;
    if (++count === k) return node.val; // in-order visits values ascending
    cur = node.right;
  }
  throw new Error("k > number of nodes");
}
```

**Mobile note:** If the tree changes often and k-th queries are hot, store subtree sizes in each node (an order-statistic tree) to answer in O(h). A sorted list behind a paging source is often the simpler mobile answer.

---

## Q11. Construct Binary Tree from Preorder and Inorder Traversal (Rebuild a Tree from Two Dumps)

**Topic:** Tree recursion + hash map

**Plan day:** Day 8

**Statement**

Given the preorder and inorder traversals of a binary tree with unique values, rebuild and return the tree.

**Approach**

Brute force: for each root scan `inorder` linearly to find it and slice arrays, O(n²). Optimal: preorder yields roots in order (consume them with a moving index); a value→index map over `inorder` splits each window into left and right subtrees in O(1).

**Complexity:** Time O(n), Space O(n)

### Kotlin

```kotlin
fun buildTree(preorder: IntArray, inorder: IntArray): TreeNode? {
    val inIndex = HashMap<Int, Int>()
    inorder.forEachIndexed { i, v -> inIndex[v] = i }
    var pre = 0 // next root in preorder
    fun build(lo: Int, hi: Int): TreeNode? { // inorder window [lo, hi]
        if (lo > hi) return null
        val node = TreeNode(preorder[pre++])
        val mid = inIndex.getValue(node.`val`)
        node.left = build(lo, mid - 1)
        node.right = build(mid + 1, hi)
        return node
    }
    return build(0, inorder.lastIndex)
}
```

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

### TypeScript

```typescript
function buildTree(preorder: number[], inorder: number[]): TreeNode | null {
  const inIndex = new Map<number, number>();
  inorder.forEach((v, i) => inIndex.set(v, i));
  let pre = 0; // next root in preorder
  const build = (lo: number, hi: number): TreeNode | null => { // inorder window [lo, hi]
    if (lo > hi) return null;
    const node = new TreeNode(preorder[pre++]);
    const mid = inIndex.get(node.val)!;
    node.left = build(lo, mid - 1);
    node.right = build(mid + 1, hi);
    return node;
  };
  return build(0, inorder.length - 1);
}
```

**Mobile note:** This is why one traversal alone cannot round-trip a tree, but preorder plus inorder (or preorder with null markers, as in Ch 27 Q5) can, which matters when you persist a navigation or layout tree.

---

## Drill checklist (say aloud)

1. Brute force in one sentence, then the optimal idea.  
2. Complexity **before** code.  
3. Name what each recursive call returns, or which pointer sits where.  
4. Edges: empty input, single element, duplicates, `k` or `n` at the boundary.  
5. One mobile sentence if it is genuinely relevant.

Previous: [Chapter 34 — Stacks & Binary Search](34-stacks-binary-search.md) · Next: [Chapter 36 — Heaps, Tries & Greedy](36-heaps-tries-greedy.md) · Related: [Chapter 24 — Interview Questions](../part-vii/24-interview-questions.md) · [Chapter 27 — Hard Drill Bank](../part-viii/27-hard-drill-bank.md)
