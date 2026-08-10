# Chapter 10 — Trees Practical (BST, Trie, JSON)

## Mobile motivation

Chapter 9 gave vocabulary and traversals. Production mobile code leans on three practical tree flavors:

1. **Binary Search Trees (BST)** — ordered keys with O(h) search/insert; mental model for sorted maps (and interview favorites).
2. **Tries (prefix trees)** — autocomplete, typeahead contacts, constrained keyboard suggestions.
3. **JSON / nested maps as trees** — almost every REST/GraphQL payload; flattening to dotted paths for analytics and form errors.

Ship the pattern, not a custom balanced tree library — platforms already give you sorted maps — but you must still *validate* BST shape, *implement* a Trie once, and *walk* nested JSON without melting the UI thread.

## Binary Search Tree (BST)

Invariant: for every node, all keys in the left subtree are **&lt;** node, all keys in the right are **&gt;** node (or ≤ / ≥ with a consistent policy for duplicates).

```text
      8
     / \
    3    10
   / \     \
  1   6     14
```

In-order traversal yields sorted keys: `1,3,6,8,10,14`.

### Search and insert

```kotlin
fun search(root: TreeNode?, key: Int): TreeNode? {
    var cur = root
    while (cur != null) {
        when {
            key == cur.value -> return cur
            key < cur.value -> cur = cur.left
            else -> cur = cur.right
        }
    }
    return null
}

fun insert(root: TreeNode?, key: Int): TreeNode {
    if (root == null) return TreeNode(key)
    if (key < root.value) root.left = insert(root.left, key)
    else if (key > root.value) root.right = insert(root.right, key)
    // equal: ignore or define multiset policy
    return root
}
```

### Complexity

| Operation | Balanced BST | Skewed BST |
|-----------|--------------|------------|
| search / insert / delete | O(log n) | O(n) |
| in-order walk | O(n) | O(n) |
| space (nodes) | O(n) | O(n) |

Mobile platforms usually expose **balanced** sorted maps (`TreeMap`, `SplayTreeMap`) when you need ordered keys. Hand-rolled BSTs are for interviews, teaching, and understanding those APIs.

## Validate BST

Not enough that it “looks mostly sorted”. A common bug: only compare each node to its immediate children. Correct approach: each node must lie in a **(low, high)** open range tightened along the path.

```typescript
function isValidBST(root: TreeNode | null): boolean {
  function go(n: TreeNode | null, lo: number | null, hi: number | null): boolean {
    if (!n) return true;
    if (lo != null && n.value <= lo) return false;
    if (hi != null && n.value >= hi) return false;
    return go(n.left, lo, n.value) && go(n.right, n.value, hi);
  }
  return go(root, null, null);
}
```

Alternatively: in-order walk and ensure values are strictly increasing.

## Tries for autocomplete

A **Trie** stores characters on edges (or in children maps). A path from the root spells a prefix; nodes marked `end` complete a word.

```text
root
 └─ a
     └─ p
         └─ p
             ├─ (end: "app")
             └─ l
                 └─ e (end: "apple")
```

| Operation | Average time (alphabet size σ) |
|-----------|--------------------------------|
| insert / search / startsWith | O(L) in word length L |
| space | O(total characters stored) — can share prefixes |

Ideal for in-memory dictionaries of tens of thousands of short tokens (emoji shortcodes, contact name tokens, city names). For huge corpora, consider platform search APIs / SQLite FTS instead of a giant Trie on the main isolate.

### Trie sketch (TypeScript)

```typescript
class TrieNode {
  children = new Map<string, TrieNode>();
  end = false;
}

class Trie {
  private root = new TrieNode();

  insert(word: string): void {
    let n = this.root;
    for (const ch of word) {
      if (!n.children.has(ch)) n.children.set(ch, new TrieNode());
      n = n.children.get(ch)!;
    }
    n.end = true;
  }

  search(word: string): boolean {
    const n = this.walk(word);
    return !!n && n.end;
  }

  startsWith(prefix: string): boolean {
    return !!this.walk(prefix);
  }

  private walk(s: string): TrieNode | null {
    let n = this.root;
    for (const ch of s) {
      const next = n.children.get(ch);
      if (!next) return null;
      n = next;
    }
    return n;
  }
}
```

Use `Map`/`HashMap` for sparse alphabets (Unicode). Fixed `array[26]` is fine for a–z interview problems.

## JSON as a tree

Decoded JSON is an n-ary tree: objects are maps of string → node; arrays are ordered lists of nodes; leaves are scalars.

```json
{
  "user": { "id": 7, "name": "Ada" },
  "tags": ["pay", "vip"]
}
```

Tree shape:

```text
(object)
├─ user (object)
│   ├─ id = 7
│   └─ name = "Ada"
└─ tags (array)
    ├─ [0] = "pay"
    └─ [1] = "vip"
```

Flattening for logs / form errors often uses **JSON path** style keys: `user.name`, `tags[0]`.

```dart
Map<String, Object?> flatten(Object? node, [String prefix = '']) {
  final out = <String, Object?>{};
  void walk(Object? n, String path) {
    if (n is Map) {
      if (n.isEmpty && path.isNotEmpty) out[path] = n;
      n.forEach((k, v) {
        final next = path.isEmpty ? '$k' : '$path.$k';
        walk(v, next);
      });
    } else if (n is List) {
      if (n.isEmpty && path.isNotEmpty) out[path] = n;
      for (var i = 0; i < n.length; i++) {
        walk(n[i], '$path[$i]');
      }
    } else {
      out[path] = n;
    }
  }
  walk(node, prefix);
  return out;
}
```

Yields `user.id → 7`, `user.name → Ada`, `tags[0] → pay`, …

## Complexity at a glance

| Structure / task | Time | Space |
|------------------|------|-------|
| BST search (balanced) | O(log n) | O(1) iter / O(h) recursion |
| Validate BST | O(n) | O(h) |
| Trie insert/search | O(L) | O(alphabet × nodes) for fixed arrays; closer to O(edges) for Map-backed tries |
| Flatten JSON | O(n nodes) | O(n) output |

## Platform bridges

| Platform | Practical tree use |
|----------|-------------------|
| **Android** | `TreeMap` for sorted keys; autocomplete `Trie`-like with `SearchView` suggestions; Gson/Moshi/Kotlinx trees → `JsonObject`. |
| **iOS** | `KeyValuePairs` / sorted dictionaries; `UISearchController` + local Trie or `CNContact` filtering; `JSONSerialization` / `Codable` nested types. |
| **Flutter** | `SplayTreeMap`; custom Trie for offline city search; `dart:convert` `jsonDecode` → nested `Map`/`List`. |
| **React Native** | Fuse.js / custom prefix index; normalized Redux trees; `JSON.parse` payloads; analytics flatteners for nested events. |

**Performance note:** Build Tries and flatten large JSON **off the UI thread** (Dispatchers.Default, background queue, compute isolate, InteractionManager). Push only the suggestion list or flat error map to the main thread.

## Worked code: BST insert + search (Swift)

```swift
final class TreeNode {
    var val: Int
    var left: TreeNode?
    var right: TreeNode?
    init(_ val: Int) { self.val = val }
}

func insert(_ root: TreeNode?, _ key: Int) -> TreeNode {
    guard let root else { return TreeNode(key) }
    if key < root.val { root.left = insert(root.left, key) }
    else if key > root.val { root.right = insert(root.right, key) }
    return root
}

func search(_ root: TreeNode?, _ key: Int) -> TreeNode? {
    var cur = root
    while let n = cur {
        if key == n.val { return n }
        cur = key < n.val ? n.left : n.right
    }
    return nil
}
```

## Worked code: Trie in Kotlin

```kotlin
class Trie {
    private class Node {
        val children = HashMap<Char, Node>()
        var end = false
    }
    private val root = Node()

    fun insert(word: String) {
        var n = root
        for (c in word) {
            n = n.children.getOrPut(c) { Node() }
        }
        n.end = true
    }

    fun search(word: String): Boolean =
        walk(word)?.end == true

    fun startsWith(prefix: String): Boolean =
        walk(prefix) != null

    private fun walk(s: String): Node? {
        var n = root
        for (c in s) {
            n = n.children[c] ?: return null
        }
        return n
    }
}
```

## Common mistakes

1. **Validating BST with only local child checks** — misses deeper violations.
2. **Allowing duplicates inconsistently** — pick &lt; vs ≤ and stick to it.
3. **Trie on full Unicode without normalization** — NFC vs NFD; decide casing policy (`toLowerCase` once).
4. **Building autocomplete on the main thread** for 100k+ words — hitch.
5. **Flattening JSON with string concatenation in hot paths** without a StringBuilder / buffer — quadratic risk in naive loops (usually fine at API sizes; watch huge docs).
6. **Assuming JSON object key order** is meaningful across platforms — do not rely on it for logic.

## Self-Check

**10.1** State the BST invariant.

**10.2** Why does range `(low, high)` beat comparing only to parent?

**10.3** What do Trie `search` and `startsWith` differ on?

**10.4** Why share prefixes in a Trie for mobile autocomplete memory?

**10.5** Give a JSON path for the second tag in `{ "tags": ["a","b"] }`.

*(Answers: Appendix D.)*

## Practice

1. **Validate BST** — [solutions/ch10](../../solutions/ch10/README.md#p1-validate-bst)
2. **Implement Trie** (`insert` / `search` / `startsWith`) — [solutions/ch10](../../solutions/ch10/README.md#p2-implement-trie)
3. **Flatten nested map keys** (JSON path style) — [solutions/ch10](../../solutions/ch10/README.md#p3-flatten-nested-map-keys)

Back: [Chapter 9 — Trees Basics](09-trees-basics.md) · Next: [Chapter 11 — Graphs Intro](11-graphs-intro.md)
