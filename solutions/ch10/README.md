# Chapter 10 — Model Solutions

## P1: Validate BST

### Approach

DFS with a legal open interval `(low, high)` for each node. Root starts with unbounded range. Left child must be `< node.val` (tighten `high`); right child must be `> node.val` (tighten `low`). Alternatively, in-order traversal must produce a strictly increasing sequence.

### Complexity

- Time: O(n)
- Space: O(h)

### Edge cases

- Empty tree → true
- Single node → true
- Equal values — typically **invalid** for strict BST (`<=` fails)
- Locally valid children but invalid deeper node — caught by ranges
- `Int.MIN/MAX` values — use nullable bounds or long sentinels to avoid overflow tricks

### Mobile note

When decoding a “sorted” settings blob into a hand-built tree, validate once in debug builds; production usually relies on `TreeMap` / sorted collections instead of raw BSTs.

### Kotlin

```kotlin
fun isValidBST(root: TreeNode?): Boolean {
    fun go(n: TreeNode?, lo: Long, hi: Long): Boolean {
        if (n == null) return true
        val v = n.value.toLong()
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
    if (lo != null && n.value <= lo) return false;
    if (hi != null && n.value >= hi) return false;
    return go(n.left, lo, n.value) && go(n.right, n.value, hi);
  }
  return go(root, null, null);
}
```

### TypeScript

```typescript
function isValidBST(root: TreeNode | null): boolean {
  function go(n: TreeNode | null, lo: number | null, hi: number | null): boolean {
    if (!n) return true;
    if (lo != null && n.val <= lo) return false;
    if (hi != null && n.val >= hi) return false;
    return go(n.left, lo, n.val) && go(n.right, n.val, hi);
  }
  return go(root, null, null);
}
```

---

## P2: Implement Trie

### Approach

Each node holds a map/array of children and an `end` flag. `insert` walks/creates nodes per character and sets `end`. `search` walks and requires `end`. `startsWith` walks and only requires the node to exist.

### Complexity

- Time: O(L) per operation (L = string length)
- Space: O(total characters inserted), sharing prefixes

### Edge cases

- Empty string — define whether allowed (`end` on root)
- `startsWith` true but `search` false — prefix only
- Duplicate inserts — idempotent `end = true`
- Case / Unicode — normalize before insert/search

### Mobile note

Build the Trie once when the dictionary downloads; query on the main thread only for short prefixes. Prefer platform search (FTS, `CNContact`) for huge datasets.

### Kotlin

```kotlin
class Trie {
    private class Node {
        val children = HashMap<Char, Node>()
        var end = false
    }
    private val root = Node()

    fun insert(word: String) {
        var n = root
        for (c in word) n = n.children.getOrPut(c) { Node() }
        n.end = true
    }

    fun search(word: String): Boolean = walk(word)?.end == true

    fun startsWith(prefix: String): Boolean = walk(prefix) != null

    private fun walk(s: String): Node? {
        var n = root
        for (c in s) n = n.children[c] ?: return null
        return n
    }
}
```

### Swift

```swift
final class Trie {
    private final class Node {
        var children: [Character: Node] = [:]
        var end = false
    }
    private let root = Node()

    func insert(_ word: String) {
        var n = root
        for c in word {
            if n.children[c] == nil { n.children[c] = Node() }
            n = n.children[c]!
        }
        n.end = true
    }

    func search(_ word: String) -> Bool { walk(word)?.end == true }

    func startsWith(_ prefix: String) -> Bool { walk(prefix) != nil }

    private func walk(_ s: String) -> Node? {
        var n = root
        for c in s {
            guard let next = n.children[c] else { return nil }
            n = next
        }
        return n
    }
}
```

### Dart

```dart
class Trie {
  final _root = _Node();

  void insert(String word) {
    var n = _root;
    for (final r in word.runes) {
      final c = String.fromCharCode(r);
      n = n.children.putIfAbsent(c, () => _Node());
    }
    n.end = true;
  }

  bool search(String word) => _walk(word)?.end == true;

  bool startsWith(String prefix) => _walk(prefix) != null;

  _Node? _walk(String s) {
    var n = _root;
    for (final r in s.runes) {
      final c = String.fromCharCode(r);
      final next = n.children[c];
      if (next == null) return null;
      n = next;
    }
    return n;
  }
}

class _Node {
  final children = <String, _Node>{};
  bool end = false;
}
```

### TypeScript

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

---

## P3: Flatten nested map keys

### Approach

Recursively walk maps and lists. Build a path string: object keys use `parent.child`; array indices use `parent[i]`. When a scalar (or empty container policy) is reached, write `path → value` into the result map.

### Complexity

- Time: O(n) over all nested nodes
- Space: O(n) for output + O(d) recursion depth

### Edge cases

- Empty root object → empty map (or single entry — define policy)
- Empty nested list/object — omit or store empty container at path
- Keys containing dots — rare; escape if needed for real analytics
- Mixed list/map nesting — path must include both `.` and `[i]`
- Root scalar — path `""` or special key

### Mobile note

Flatten API errors (`user.address.line1`) for inline form field highlighting; run on a background isolate/thread when payloads are large.

### Kotlin

```kotlin
@Suppress("UNCHECKED_CAST")
fun flatten(node: Any?, prefix: String = ""): Map<String, Any?> {
    val out = LinkedHashMap<String, Any?>()
    fun walk(n: Any?, path: String) {
        when (n) {
            is Map<*, *> -> {
                if (n.isEmpty() && path.isNotEmpty()) out[path] = n
                for ((k, v) in n) {
                    val next = if (path.isEmpty()) "$k" else "$path.$k"
                    walk(v, next)
                }
            }
            is List<*> -> {
                if (n.isEmpty() && path.isNotEmpty()) out[path] = n
                n.forEachIndexed { i, v -> walk(v, "$path[$i]") }
            }
            else -> out[path] = n
        }
    }
    walk(node, prefix)
    return out
}
```

### Swift

```swift
func flatten(_ node: Any, prefix: String = "") -> [String: Any?] {
    var out: [String: Any?] = [:]
    func walk(_ n: Any, _ path: String) {
        if let dict = n as? [String: Any] {
            if dict.isEmpty && !path.isEmpty { out[path] = dict }
            for (k, v) in dict {
                let next = path.isEmpty ? k : "\(path).\(k)"
                walk(v, next)
            }
        } else if let arr = n as? [Any] {
            if arr.isEmpty && !path.isEmpty { out[path] = arr }
            for (i, v) in arr.enumerated() {
                walk(v, "\(path)[\(i)]")
            }
        } else {
            out[path] = n
        }
    }
    walk(node, prefix)
    return out
}
```

### Dart

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

### TypeScript

```typescript
type Json = null | boolean | number | string | Json[] | { [k: string]: Json };

function flatten(node: Json, prefix = ''): Map<string, Json> {
  const out = new Map<string, Json>();
  const walk = (n: Json, path: string) => {
    if (n !== null && typeof n === 'object' && !Array.isArray(n)) {
      const keys = Object.keys(n);
      if (!keys.length && path) out.set(path, n);
      for (const k of keys) {
        const next = path ? `${path}.${k}` : k;
        walk(n[k], next);
      }
    } else if (Array.isArray(n)) {
      if (!n.length && path) out.set(path, n);
      n.forEach((v, i) => walk(v, `${path}[${i}]`));
    } else {
      out.set(path, n);
    }
  };
  walk(node, prefix);
  return out;
}
```
