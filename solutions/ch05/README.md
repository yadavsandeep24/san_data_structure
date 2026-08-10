# Chapter 5 — Model Solutions

## P1: Valid parentheses

### Approach

Scan left to right. Push opening brackets onto a stack. On a closing bracket, pop and verify it matches; mismatch or empty stack ⇒ invalid. Success requires an empty stack at the end.

### Complexity

- Time: O(n)
- Space: O(n) worst case (all openers)

### Edge cases

- Empty string → valid
- Only closers / only openers → invalid
- Interleaved wrong types `([)]` → invalid
- Long strings → stack depth equals open count; still fine vs recursion

### Mobile note

Same pattern validates nested navigation deep-links or custom markup before rendering. Keep it iterative; do not recurse on untrusted input length.

### Kotlin

```kotlin
fun isValid(s: String): Boolean {
    val st = ArrayDeque<Char>()
    val pair = mapOf(')' to '(', ']' to '[', '}' to '{')
    for (c in s) {
        when (c) {
            '(', '[', '{' -> st.addLast(c)
            else -> if (st.isEmpty() || st.removeLast() != pair[c]) return false
        }
    }
    return st.isEmpty()
}
```

### Swift

```swift
func isValid(_ s: String) -> Bool {
    var st: [Character] = []
    let pair: [Character: Character] = [")": "(", "]": "[", "}": "{"]
    for c in s {
        if c == "(" || c == "[" || c == "{" {
            st.append(c)
        } else if st.isEmpty || st.removeLast() != pair[c] {
            return false
        }
    }
    return st.isEmpty
}
```

### Dart

```dart
bool isValid(String s) {
  final st = <String>[];
  const pair = {')': '(', ']': '[', '}': '{'};
  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    if (c == '(' || c == '[' || c == '{') {
      st.add(c);
    } else if (st.isEmpty || st.removeLast() != pair[c]) {
      return false;
    }
  }
  return st.isEmpty;
}
```

### TypeScript

```typescript
function isValid(s: string): boolean {
  const st: string[] = [];
  const pair: Record<string, string> = { ')': '(', ']': '[', '}': '{' };
  for (const c of s) {
    if (c === '(' || c === '[' || c === '{') st.push(c);
    else if (!st.length || st.pop() !== pair[c]) return false;
  }
  return st.length === 0;
}
```

---

## P2: Min stack

### Approach

Store values on one stack and the running minimum on a second stack (same size). On push, record `min(x, currentMin)`. On pop, pop both. `getMin` is a peek on the mins stack — O(1).

Alternative: store pairs `(value, minSoFar)` in one stack.

### Complexity

- All operations: O(1) time
- Space: O(n)

### Edge cases

- Pop/top/getMin on empty — define API (throw vs optional); interviews usually guarantee valid calls
- Duplicate minima — both stacks must keep one entry per push so counts stay aligned
- Negatives and `Int.MIN_VALUE`

### Mobile note

Use for live “lowest RSS / lowest battery sample in session” without scanning history each frame. Bound history length if samples are continuous.

### Kotlin

```kotlin
class MinStack {
    private val vals = ArrayDeque<Int>()
    private val mins = ArrayDeque<Int>()

    fun push(x: Int) {
        vals.addLast(x)
        mins.addLast(if (mins.isEmpty()) x else minOf(x, mins.last()))
    }

    fun pop() {
        vals.removeLast()
        mins.removeLast()
    }

    fun top(): Int = vals.last()
    fun getMin(): Int = mins.last()
}
```

### Swift

```swift
final class MinStack {
    private var vals: [Int] = []
    private var mins: [Int] = []

    func push(_ x: Int) {
        vals.append(x)
        mins.append(mins.last.map { min(x, $0) } ?? x)
    }

    func pop() {
        vals.removeLast()
        mins.removeLast()
    }

    func top() -> Int { vals.last! }
    func getMin() -> Int { mins.last! }
}
```

### Dart

```dart
class MinStack {
  final _vals = <int>[];
  final _mins = <int>[];

  void push(int x) {
    _vals.add(x);
    _mins.add(_mins.isEmpty ? x : (x < _mins.last ? x : _mins.last));
  }

  void pop() {
    _vals.removeLast();
    _mins.removeLast();
  }

  int top() => _vals.last;
  int getMin() => _mins.last;
}
```

### TypeScript

```typescript
class MinStack {
  private vals: number[] = [];
  private mins: number[] = [];

  push(x: number): void {
    this.vals.push(x);
    const m = this.mins.length ? Math.min(x, this.mins[this.mins.length - 1]) : x;
    this.mins.push(m);
  }

  pop(): void {
    this.vals.pop();
    this.mins.pop();
  }

  top(): number { return this.vals[this.vals.length - 1]; }
  getMin(): number { return this.mins[this.mins.length - 1]; }
}
```

---

## P3: Simplify absolute path

### Approach

Split on `/`. Use a stack of path segments. Ignore `""` and `"."`. On `".."`, pop if non-empty. Other tokens push. Join with `/` and prefix `/`. Root `..` stays at root (no pop past empty).

### Complexity

- Time: O(n) where n is path length
- Space: O(n)

### Edge cases

- `/../` → `/`
- `/home//foo/` → `/home/foo`
- `/a/./b/../../c/` → `/c`
- Trailing slash
- Unicode segment names (treat as opaque tokens)

### Mobile note

Useful when normalizing deep-link paths or file URIs before comparison. Never `eval` path strings; stack-normalize then allowlist prefixes.

### Kotlin

```kotlin
fun simplifyPath(path: String): String {
    val st = ArrayDeque<String>()
    for (part in path.split('/')) {
        when (part) {
            "", "." -> Unit
            ".." -> if (st.isNotEmpty()) st.removeLast()
            else -> st.addLast(part)
        }
    }
    return "/" + st.joinToString("/")
}
```

### Swift

```swift
func simplifyPath(_ path: String) -> String {
    var st: [String] = []
    for part in path.split(separator: "/", omittingEmptySubsequences: false).map(String.init) {
        switch part {
        case "", ".": break
        case "..": if !st.isEmpty { st.removeLast() }
        default: st.append(part)
        }
    }
    return "/" + st.joined(separator: "/")
}
```

### Dart

```dart
String simplifyPath(String path) {
  final st = <String>[];
  for (final part in path.split('/')) {
    if (part.isEmpty || part == '.') continue;
    if (part == '..') {
      if (st.isNotEmpty) st.removeLast();
    } else {
      st.add(part);
    }
  }
  return '/${st.join('/')}';
}
```

### TypeScript

```typescript
function simplifyPath(path: string): string {
  const st: string[] = [];
  for (const part of path.split('/')) {
    if (part === '' || part === '.') continue;
    if (part === '..') {
      if (st.length) st.pop();
    } else {
      st.push(part);
    }
  }
  return '/' + st.join('/');
}
```
