# Chapter 9 — Trees Basics

## Mobile motivation

Open the view debugger on any screen. You are looking at a **tree**: a window root, then navigation host, then scroll view, then rows, then labels and icons. Compose / SwiftUI / Flutter / React Native all build **UI trees**. File managers, JSON documents, accessibility hierarchies, and nested comment threads are trees too.

Linear structures (arrays, lists, stacks, queues) have one neighbor relationship. Trees branch. Once you can talk about **root, leaf, height, and traversals**, “walk every node” stops being vague — and BFS level-order (Chapter 6’s queue) becomes the tool for “layout layer by layer”.

## Core vocabulary

| Term | Meaning |
|------|---------|
| **Node** | A value plus links to children |
| **Root** | The unique top node (no parent) |
| **Leaf** | A node with no children |
| **Edge** | Parent → child link |
| **Parent / child / sibling** | Family metaphor for one hop / same parent |
| **Depth** | Nodes on root→this path (root depth **1** in this book) |
| **Height** | Longest downward path in **nodes** (single node height **1**) |
| **Subtree** | A node plus all its descendants |

**Convention in this book (interviews):** `maxDepth(null) = 0`; a single-node tree has depth/height **1** (count nodes on the root→leaf path). Graph-theory edge-count depth / leaf height 0 appears in some textbooks — if an interviewer uses that, say so and stay consistent.

```text
        A          ← root (height 3 in node-count convention)
       / \
      B   C        ← depth 2
     / \
    D   E          ← leaves (also C)
```

### View hierarchy as a tree

| Framework | Root-ish | Children |
|-----------|----------|----------|
| Android Views | DecorView / Compose root | `childCount` / Compose slot tree |
| UIKit | UIWindow → rootViewController.view | `subviews` |
| SwiftUI | View tree (structural) | nested `View` builders |
| Flutter | `Element` / `RenderObject` trees | child elements |
| React Native | Host root fiber | child fibers / native views |

Recycling lists do **not** keep one native view per model forever — but the **logical** UI description is still hierarchical.

### Android: View tree vs Compose tree — what depth costs

Android gives you two UI trees with different traversal costs, and many apps have both (a `ComposeView` is a **leaf View** that hosts a whole Compose tree; `AndroidView` is a Compose node that hosts a View subtree).

| | View system (XML / `ViewGroup`) | Jetpack Compose |
|---|---|---|
| Tree | `View` / `ViewGroup` objects; XML inflation builds it once | Composition tree (composables recorded in the slot table) emitting a `LayoutNode` tree |
| Per-frame work | Three recursive passes from the root: **measure** (`onMeasure`) → **layout** (`onLayout`) → **draw** (`onDraw`, recorded into display lists) | Three phases: **composition** (run composables whose inputs changed) → **layout** (measure + place) → **drawing** |
| What triggers work | `requestLayout()` marks the view and every ancestor up to the root (O(depth)), so the next frame re-measures that path; `invalidate()` → redraw only | A changed `State` that was read: composition-phase reads → recompose; layout-phase reads → re-layout only; draw-phase reads → redraw only |
| Measuring children | A parent may measure a child **more than once**: `LinearLayout` with `layout_weight`, `RelativeLayout` measure twice. Nest them *k* deep and the leaf can be measured ~2^*k* times — the "double taxation" behind "keep the View hierarchy flat" (`ConstraintLayout`, `merge`) | **Single-pass measurement**: a layout may measure each child only once per pass (measuring twice throws). Parents that need a child's size first ask **intrinsic** measurements instead |
| Cost of depth | Expensive: every level adds measure/layout recursion, and nested weights multiply it | Cheap: nesting `Row`/`Column`/`Box` is linear; the cost to watch is **how much recomposes**, not how deep |
| Unit of re-execution | The invalidated View and its subtree on the next traversal | The **recomposition scope**: the nearest restartable composable that read the changed state. `Column`/`Row`/`Box` are inline and do not create their own scope — split work into small composables so a change re-runs a small subtree |
| Debugging the tree | Layout Inspector; `adb shell dumpsys activity top` (prints the View tree); `ViewGroup.getChildAt` walks | Layout Inspector (recomposition counts); `onRoot().printToLog(tag)` in UI tests prints the semantics tree |

Interview phrasing: *a deep View hierarchy is a measure/layout problem; a wide Compose recomposition is a composition problem.* The fix for the first is flattening; the fix for the second is narrower state reads (pass lambdas, read state in the lowest composable, defer reads to layout/draw).

**Kotlin — Views: depth of a real `ViewGroup` tree, iteratively**

The same max-depth algorithm as below, applied to an n-ary View tree with an explicit stack (safe for pathological depth):

```kotlin
fun maxViewDepth(root: View): Int {
    val stack = ArrayDeque<Pair<View, Int>>()
    stack.addLast(root to 1)
    var max = 0
    while (stack.isNotEmpty()) {
        val (view, depth) = stack.removeLast()
        max = maxOf(max, depth)
        if (view is ViewGroup) {
            for (i in 0 until view.childCount) stack.addLast(view.getChildAt(i) to depth + 1)
        }
    }
    return max
}
```

**Kotlin — Compose: keep the recomposition scope small**

```kotlin
@Composable
fun CartHeader(itemCount: Int, total: () -> String) {
    Column {
        Text("$itemCount items")   // not re-run when only the total changes
        TotalLine(total)           // total() is read inside → only this scope recomposes
    }
}

@Composable
fun TotalLine(total: () -> String) = Text(total())

@Composable
fun ParallaxHeader(scroll: ScrollState) {
    // Read scroll in the layout phase (lambda offset): no recomposition per pixel.
    Box(Modifier.offset { IntOffset(0, scroll.value / 2) })
}
```

## Binary trees

A **binary tree** gives each node at most two children: `left` and `right`. Many interview problems use binary trees because the API is small and recursion is natural.

```kotlin
class TreeNode(var value: Int) {
    var left: TreeNode? = null
    var right: TreeNode? = null
}
```

Special shapes (informal):

| Shape | Description |
|-------|-------------|
| Full | Every node has 0 or 2 children |
| Complete | Filled level by level, left to right |
| Perfect | All leaves at same depth; every node has 2 children |
| Skewed | Degenerates toward a linked list (height ≈ n) |

Height matters: algorithms that are O(h) become O(n) on skewed trees — motivation for balanced BSTs later.

## Traversals

Visiting every node exactly once. Four classics:

| Order | Visit sequence | Mental model |
|-------|----------------|--------------|
| **Pre-order** | node → left → right | Serialize / copy tree; “process parent before children” |
| **In-order** | left → node → right | On a BST, yields sorted values |
| **Post-order** | left → right → node | Delete tree; compute size/height bottom-up |
| **Level-order** | BFS by depth | UI layers; shortest path in unweighted trees |

### Recursive templates

```typescript
function preorder(n: TreeNode | null, visit: (v: number) => void): void {
  if (!n) return;
  visit(n.value);
  preorder(n.left, visit);
  preorder(n.right, visit);
}

function inorder(n: TreeNode | null, visit: (v: number) => void): void {
  if (!n) return;
  inorder(n.left, visit);
  visit(n.value);
  inorder(n.right, visit);
}

function postorder(n: TreeNode | null, visit: (v: number) => void): void {
  if (!n) return;
  postorder(n.left, visit);
  postorder(n.right, visit);
  visit(n.value);
}
```

### Level-order with a queue

```kotlin
fun levelOrder(root: TreeNode?): List<List<Int>> {
    if (root == null) return emptyList()
    val res = mutableListOf<List<Int>>()
    val q = ArrayDeque<TreeNode>()
    q.addLast(root)
    while (q.isNotEmpty()) {
        val level = mutableListOf<Int>()
        repeat(q.size) {
            val node = q.removeFirst()
            level += node.value
            node.left?.let { q.addLast(it) }
            node.right?.let { q.addLast(it) }
        }
        res += level
    }
    return res
}
```

## Complexity at a glance

| Algorithm | Time | Extra space |
|-----------|------|-------------|
| Any full traversal | O(n) | O(h) recursion stack, or O(w) queue (w = max width) |
| Max depth (height) | O(n) | O(h) |
| Search in unstructured binary tree | O(n) | O(h) |

There is no free lunch: without ordering invariants (BST), finding a value may require visiting every node.

## File system as a tree

Directories are nodes; files are usually leaves (or nodes with metadata only). “List all `.kt` files under `src/`” is a tree walk — typically DFS recursion or an explicit stack; “show this folder’s immediate children” is one level.

```dart
class FsNode {
  FsNode(this.name, {this.isDirectory = false, this.children = const []});
  final String name;
  final bool isDirectory;
  final List<FsNode> children;
  bool get isFile => !isDirectory;
}

void walk(FsNode n, void Function(FsNode) visit) {
  visit(n);
  for (final c in n.children) walk(c, visit);
}
```

Empty directories are still directories — never infer file vs folder from `children.isEmpty` alone.
Mobile parallel: walking a nested JSON settings blob or a Compose/SwiftUI preview hierarchy for debugging.

## Platform bridges

| Platform | Tree you already touch |
|----------|------------------------|
| **Android** | View / Compose UI tree; XML resource inflation; navigation graph (also a graph — Chapter 11); file trees via `DocumentFile`. |
| **iOS** | UIView hierarchy; SwiftUI view tree; `FileManager` directory enumeration; Auto Layout constraint graph (more general). |
| **Flutter** | Widget → Element → RenderObject trees; `visitChildren`; DevTools widget inspector. |
| **React Native** | React fiber tree; Yoga layout tree; Metro’s module graph (build-time). |

**Mobile tip:** Deep recursion on a skewed tree can stack-overflow on mobile (smaller stacks than servers). Prefer iterative stack/queue for untrusted depth (e.g. pathological JSON).

## Worked code: max depth

Height of the tree = max depth of any node (root depth 1 counting style used in many interview problems: empty → 0).

### Kotlin

```kotlin
fun maxDepth(root: TreeNode?): Int {
    if (root == null) return 0
    return 1 + maxOf(maxDepth(root.left), maxDepth(root.right))
}
```

### Swift

```swift
func maxDepth(_ root: TreeNode?) -> Int {
    guard let root else { return 0 }
    return 1 + max(maxDepth(root.left), maxDepth(root.right))
}
```

### Dart

```dart
int maxDepth(TreeNode? root) {
  if (root == null) return 0;
  return 1 + max(maxDepth(root.left), maxDepth(root.right));
}
```

### TypeScript

```typescript
function maxDepth(root: TreeNode | null): number {
  if (!root) return 0;
  return 1 + Math.max(maxDepth(root.left), maxDepth(root.right));
}
```

## Pattern: invert binary tree

Swap left and right at every node (mirror). Pre-order or post-order both work; BFS works too.

```swift
func invertTree(_ root: TreeNode?) -> TreeNode? {
    guard let root else { return nil }
    let tmp = root.left
    root.left = invertTree(root.right)
    root.right = invertTree(tmp)
    return root
}
```

## Pattern: same tree

Two trees are the same if structure and values match. Recurse on pairs of nodes.

```kotlin
fun isSameTree(p: TreeNode?, q: TreeNode?): Boolean {
    if (p == null && q == null) return true
    if (p == null || q == null) return false
    if (p.value != q.value) return false
    return isSameTree(p.left, q.left) && isSameTree(p.right, q.right)
}
```

## Common mistakes

1. **Off-by-one height conventions** — document whether leaf height is 0 and empty is 0 or −1.
2. **Forgetting null children** — every recursive call needs a base case.
3. **Confusing depth and height** — depth is from root down; height is from node down.
4. **Assuming binary** when the real UI tree is n-ary — generalize to `children: List`.
5. **Recursing too deep** on mobile for untrusted input — use iterative traversal.
6. **Mutating while sharing subtrees** — inverted tree may need copies if nodes are reused immutably (SwiftUI/Compose mindset).
7. **Treating View depth and Compose depth as the same cost** — nested `LinearLayout` weights multiply measure passes; nested `Column`s do not. In Compose, worry about recomposition breadth instead.

## Self-Check

**9.1** Define root, leaf, and height for a binary tree.

**9.2** Which traversal of a BST visits values in sorted order?

**9.3** Why does level-order use a queue instead of recursion alone?

**9.4** Give one mobile example of an n-ary tree (not necessarily binary).

**9.5** What is the time complexity of visiting every node once?

**9.6** Why is a deeply nested View hierarchy more expensive than an equally deep Compose layout?

*(Answers: Appendix D.)*

## Practice

1. **Maximum depth of binary tree** — [solutions/ch09](../../solutions/ch09/README.md#p1-maximum-depth)
2. **Invert binary tree** — [solutions/ch09](../../solutions/ch09/README.md#p2-invert-binary-tree)
3. **Same tree** — [solutions/ch09](../../solutions/ch09/README.md#p3-same-tree)

Back: [Chapter 8 — Sets](08-sets.md) · Next: [Chapter 10 — Trees Practical](10-trees-practical.md)
