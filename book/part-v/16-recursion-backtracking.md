# Chapter 16 — Recursion and Backtracking

## Mobile motivation

UI trees are recursive: a `ViewGroup` contains children that contain children; a Jetpack Compose `Column` emits child layout nodes that emit their own; a SwiftUI/Flutter widget builds a tree; a React component tree reconciles depth-first. Walking that structure with recursion feels natural — until a pathological depth (deeply nested comments, crafted HTML, huge JSON) blows the **native call stack** and the process dies with little ceremony.

Backtracking — try a choice, recurse, undo — shines in interviews (subsets, combinations, mazes). In shipping apps it appears rarely: puzzle games, constraint solvers, sometimes codegen. Most product code should prefer iteration, explicit stacks, or library solvers. Learn the template anyway; know when to leave it on the whiteboard.

## Base case + recursive case

Every correct recursive function needs:

1. **Base case** — input so small you answer without calling yourself (empty list, `n == 0`, leaf node).
2. **Recursive case** — smaller subproblem(s) plus a combine step.
3. **Progress** — each call must move toward a base case (decrement `n`, shrink the slice, advance an index).

Missing any of these produces infinite recursion → stack overflow.

```text
fun f(state):
  if done(state): return answer          // base
  choose / shrink
  result = f(nextState)                  // recursive
  undo if backtracking
  return combine(result)
```

### Tiny example — factorial (teaching only)

**Kotlin**

```kotlin
fun fact(n: Int): Long =
    if (n <= 1) 1L else n * fact(n - 1)
```

**Swift**

```swift
func fact(_ n: Int) -> Int {
    n <= 1 ? 1 : n * fact(n - 1)
}
```

**Dart**

```dart
int fact(int n) => n <= 1 ? 1 : n * fact(n - 1);
```

**TypeScript**

```typescript
function fact(n: number): number {
  return n <= 1 ? 1 : n * fact(n - 1); // exact through 22!, but past 18! it exceeds MAX_SAFE_INTEGER — use bigint
}
```

Prefer a loop for real factorial; the point is the shape: base `n <= 1`, recursive `n - 1`.

## View-tree recursion (mobile-shaped)

Count leaves in a simplified view tree, or find the first node matching an ID — the same DFS pattern as binary trees (Chapter 9–10).

**Kotlin**

```kotlin
data class ViewNode(val id: String, val children: List<ViewNode> = emptyList())

fun countLeaves(node: ViewNode): Int {
    if (node.children.isEmpty()) return 1
    return node.children.sumOf { countLeaves(it) }
}

fun findById(node: ViewNode, target: String): ViewNode? {
    if (node.id == target) return node
    for (c in node.children) {
        findById(c, target)?.let { return it }
    }
    return null
}
```

**Swift**

```swift
final class ViewNode {
    let id: String
    var children: [ViewNode]
    init(_ id: String, children: [ViewNode] = []) {
        self.id = id; self.children = children
    }
}

func countLeaves(_ node: ViewNode) -> Int {
    if node.children.isEmpty { return 1 }
    return node.children.reduce(0) { $0 + countLeaves($1) }
}
```

**Dart**

```dart
class ViewNode {
  final String id;
  final List<ViewNode> children;
  ViewNode(this.id, [this.children = const []]);
}

int countLeaves(ViewNode node) {
  if (node.children.isEmpty) return 1;
  return node.children.fold(0, (s, c) => s + countLeaves(c));
}
```

**TypeScript**

```typescript
type ViewNode = { id: string; children?: ViewNode[] };

function countLeaves(node: ViewNode): number {
  const kids = node.children ?? [];
  if (!kids.length) return 1;
  return kids.reduce((s, c) => s + countLeaves(c), 0);
}
```

For production tree walks over untrusted depth, prefer an **explicit stack** (Chapter 5) so max depth is heap-limited and catchable.

## Call stack risk on mobile

| Concern | Reality |
|---------|---------|
| Default stack size | Smaller / less forgiving than desktop servers; varies by OS and thread |
| Deep JSON / XML | Recursive parsers can crash; prefer iterative or streaming parsers |
| Tail-call optimization | **Not** reliable in Kotlin, Swift, Dart, or JS engines you ship |
| Main thread | Stack overflow still kills the process; UI thread is not magically safer |
| Coroutines / isolates | Different stacks per worker — still finite |

**Practical rule:** if depth can exceed a few hundred from user or network data, do not recurse. Cap depth when you must recurse (e.g. max 32 nested layout groups) and fail soft.

## Backtracking template

Backtracking explores a decision tree:

```text
def backtrack(path, choices):
  if is_solution(path):
    record(path)
    return
  for choice in choices_at(path):
    if not valid(choice, path): continue
    path.add(choice)           // choose
    backtrack(path, ...)       // explore
    path.remove(choice)        // undo (backtrack)
```

Key discipline: **undo** every mutation so sibling branches see a clean state. Mutating a shared list without undo is the #1 silent bug.

### Subsets pattern (include / exclude)

For each index, either take `nums[i]` or skip it. Record a copy of `path` at every node (or only at leaves — both are valid subset definitions; interviews usually want every partial path).

### Combination sum pattern

At index `i`, try each candidate `>= i` (to avoid permutations of the same multiset), subtract from remaining target, recurse, pop.

### Phone letter combinations

Map digit → letters. At position `i` in the digits string, try each letter, recurse to `i + 1`, pop. Base: `i == digits.length` → record.

## When backtracking is interview-only

Use backtracking in product code when:

- The search space is tiny and bounded (levels of a game, short PIN patterns).
- You need *all* solutions and n is small (n ≤ ~15 for 2ⁿ patterns, smaller for factorial).

Do **not** use raw backtracking for:

- Scheduling thousands of calendar events (use greedy / DP / ILP services).
- Matching large catalogs (use indexes, ranking services).
- Layout constraint solving (use the platform’s layout engine).

Interviewers love subsets / combinations / word search because they test the template. Shipping apps love databases, caches, and heuristics.

## Worked: letter combinations (sketch)

Digit map: `2→abc`, `3→def`, …

**Kotlin**

```kotlin
fun letterCombinations(digits: String): List<String> {
    if (digits.isEmpty()) return emptyList()
    val map = arrayOf("", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz")
    val out = mutableListOf<String>()
    val path = StringBuilder()
    fun dfs(i: Int) {
        if (i == digits.length) { out += path.toString(); return }
        for (c in map[digits[i] - '0']) {
            path.append(c)
            dfs(i + 1)
            path.deleteCharAt(path.lastIndex)
        }
    }
    dfs(0)
    return out
}
```

**Swift** — `wholeNumberValue` instead of force-unwrapping `asciiValue`

```swift
func letterCombinations(_ digits: String) -> [String] {
    if digits.isEmpty { return [] }
    let map = ["", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"]
    let ds = digits.compactMap(\.wholeNumberValue)
    var out: [String] = []
    var path = ""
    func dfs(_ i: Int) {
        if i == ds.count { out.append(path); return }
        for c in map[ds[i]] {
            path.append(c)
            dfs(i + 1)
            path.removeLast()
        }
    }
    dfs(0)
    return out
}
```

**Dart**

```dart
List<String> letterCombinations(String digits) {
  if (digits.isEmpty) return [];
  const map = ['', '', 'abc', 'def', 'ghi', 'jkl', 'mno', 'pqrs', 'tuv', 'wxyz'];
  final out = <String>[];
  final path = <String>[];
  void dfs(int i) {
    if (i == digits.length) {
      out.add(path.join());
      return;
    }
    final letters = map[digits.codeUnitAt(i) - 48];
    for (var k = 0; k < letters.length; k++) {
      path.add(letters[k]);
      dfs(i + 1);
      path.removeLast();
    }
  }
  dfs(0);
  return out;
}
```

**TypeScript**

```typescript
function letterCombinations(digits: string): string[] {
  if (!digits) return [];
  const map = ["", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz"];
  const out: string[] = [];
  const path: string[] = [];
  const dfs = (i: number) => {
    if (i === digits.length) {
      out.push(path.join(""));
      return;
    }
    for (const c of map[digits.charCodeAt(i) - 48]) {
      path.push(c);
      dfs(i + 1);
      path.pop();
    }
  };
  dfs(0);
  return out;
}
```

Full four-language solutions for subsets, combination sum, and letters live under `solutions/ch16`.

## Common mistakes

1. Forgetting the base case or never shrinking the problem.
2. Recording `path` by reference — all results end up identical; **copy** (`toList()`, `[...]`).
3. Not undoing a push before the next sibling choice.
4. Recursing on main thread over deep user content.
5. Using backtracking where a closed-form or DP solution is O(n).

## Self-Check

**16.1** What three ingredients must every recursive function have?

**16.2** Why is view-tree recursion attractive yet dangerous for unbounded input?

**16.3** What does the “undo” step in backtracking accomplish?

**16.4** When should you replace recursion with an explicit stack on mobile?

**16.5** Name one product feature where backtracking is reasonable and one where it is not.

*(Answers: Appendix D.)*

## Practice

1. **Subsets** — [solutions/ch16](../../solutions/ch16/README.md#p1-subsets)
2. **Combination sum** — [solutions/ch16](../../solutions/ch16/README.md#p2-combination-sum)
3. **Phone letter combinations** — [solutions/ch16](../../solutions/ch16/README.md#p3-phone-letter-combinations)

Next: [Chapter 17 — Greedy Thinking](17-greedy-thinking.md) — local choices, proofs of failure, and jump-game style reasoning.
