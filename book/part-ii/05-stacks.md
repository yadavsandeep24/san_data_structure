# Chapter 5 — Stacks

## Mobile motivation

Tap Back on Android. Swipe from the edge on iOS. Press the browser-style back affordance in a Flutter or React Navigation stack. Somewhere under that gesture sits a **stack**: the screen you leave is pushed; the screen you return to is popped. If that structure is wrong — duplicate routes, missing pops, or work done on every intermediate frame — users feel lost navigation and janky transitions.

Stacks also power undo/redo in editors, matching brackets in expression validators, DFS recursion (the call stack itself), and parsing deep JSON payloads without blowing the real stack. Understanding LIFO is how you debug “why did this screen reappear?” and “why did we OOM on a recursive tree walk?”

## What a stack is

A **stack** is Last-In, First-Out (LIFO). You only touch the top.

| Operation | Meaning | Target complexity |
|-----------|---------|-------------------|
| `push(x)` | Place `x` on top | O(1) amortized |
| `pop()` | Remove and return top | O(1) |
| `peek` / `top` | Read top without remove | O(1) |
| `isEmpty` | Empty check | O(1) |

You may implement a stack with a dynamic array (push/pop at the end) or a linked list (push/pop at the head). On modern mobile runtimes, **array-backed stacks win**: better locality, fewer allocations.

### Array as stack

- Kotlin: `ArrayDeque` (prefer) or `mutableListOf` with `add` / `removeLast`
- Swift: `Array` with `append` / `removeLast`
- Dart: `List` with `add` / `removeLast`
- TypeScript: `number[]` or generic `T[]` with `push` / `pop`

**Never** `removeAt(0)` / `removeFirst()` for stack behavior — that is O(n) and turns your “stack” into a slow queue.

## Complexity at a glance

| Backing | push | pop | peek | notes |
|---------|------|-----|------|-------|
| Dynamic array (end) | O(1) amortized | O(1) | O(1) | Preferred |
| Singly list (head) | O(1) | O(1) | O(1) | Extra node allocs |
| Array remove-from-front | O(n) | O(n) | O(1) | Anti-pattern |

## Platform bridges — navigation back-stacks

| Platform | Stack you touch |
|----------|-----------------|
| **Android** | `NavController` back stack; Activity task affinity; FragmentManager back stack. `popBackStack()` is the UI `pop`. |
| **iOS** | `UINavigationController` push/pop; SwiftUI `NavigationPath` is an explicit stack of values. |
| **Flutter** | `Navigator` / `Router` — `push` / `pop` / `popUntil`. `WillPopScope` / `PopScope` intercepts the pop. |
| **React Native** | React Navigation stack navigator; `navigation.push` / `goBack`; state is a route stack in the container. |

Mental model: **route identity lives on a stack**; presentation (animation, shared element) is layered on top. Bugs labeled “navigation” are often stack discipline bugs: push without matching pop, or pop while async work still expects that route to exist.

## Undo / redo

Model an editor with two stacks:

1. **Undo stack** — each successful edit pushes an inverse command (or a snapshot delta).
2. **Redo stack** — cleared on a new edit; undo pops undo and pushes onto redo; redo reverses that.

```text
type → push undo, clear redo
undo → pop undo, apply inverse, push redo
redo → pop redo, apply forward, push undo
```

Bound both stacks (e.g. 50–100 ops) so memory stays predictable on phones.

## Connection to the call stack

Every function call pushes a frame; every return pops one. Deep recursion (parsing nested comments, walking a skewed tree) can overflow the **native** call stack even when your heap is fine. On mobile:

- Prefer iterative algorithms with an **explicit** `ArrayDeque` / `Array` stack when depth can hit thousands.
- Tail recursion is not reliably optimized in Kotlin/Swift/Dart/JS the way it is in some functional VMs.
- Crash reports saying `StackOverflowError` / EXC_BAD_ACCESS near recursive helpers are your cue to convert to an explicit stack.

## Worked examples (four languages)

### Minimal stack wrapper

**Kotlin**

```kotlin
class Stack<T> {
    private val data = ArrayDeque<T>()
    fun push(x: T) = data.addLast(x)
    fun pop(): T = data.removeLast()
    fun peek(): T = data.last()
    fun isEmpty() = data.isEmpty()
}
```

**Swift**

```swift
struct Stack<Element> {
    private var data: [Element] = []
    mutating func push(_ x: Element) { data.append(x) }
    mutating func pop() -> Element? { data.popLast() }
    func peek() -> Element? { data.last }
    var isEmpty: Bool { data.isEmpty }
}
```

**Dart**

```dart
class Stack<E> {
  final _data = <E>[];
  void push(E x) => _data.add(x);
  E pop() => _data.removeLast();
  E get peek => _data.last;
  bool get isEmpty => _data.isEmpty;
}
```

**TypeScript**

```typescript
class Stack<T> {
  private data: T[] = [];
  push(x: T): void { this.data.push(x); }
  pop(): T | undefined { return this.data.pop(); }
  peek(): T | undefined { return this.data[this.data.length - 1]; }
  isEmpty(): boolean { return this.data.length === 0; }
}
```

### Valid parentheses (classic)

Push opening brackets; on close, pop and match. Empty stack at the end ⇒ valid.

**Kotlin**

```kotlin
fun isValid(s: String): Boolean {
    val st = ArrayDeque<Char>()
    val pair = mapOf(')' to '(', ']' to '[', '}' to '{')
    for (c in s) {
        if (c in "([{") st.addLast(c)
        else if (st.isEmpty() || st.removeLast() != pair[c]) return false
    }
    return st.isEmpty()
}
```

**Swift**

```swift
func isValid(_ s: String) -> Bool {
    var st: [Character] = []
    let pair: [Character: Character] = [")": "(", "]": "[", "}": "{"]
    for c in s {
        if "([{".contains(c) { st.append(c) }
        else if st.isEmpty || st.removeLast() != pair[c] { return false }
    }
    return st.isEmpty
}
```

**Dart**

```dart
bool isValid(String s) {
  final st = <String>[];
  const pair = {')': '(', ']': '[', '}': '{'};
  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    if ('([{'.contains(c)) {
      st.add(c);
    } else if (st.isEmpty || st.removeLast() != pair[c]) {
      return false;
    }
  }
  return st.isEmpty;
}
```

**TypeScript**

```typescript
function isValid(s: string): boolean {
  const st: string[] = [];
  const pair: Record<string, string> = { ')': '(', ']': '[', '}': '{' };
  for (const c of s) {
    if ('([{'.includes(c)) st.push(c);
    else if (!st.length || st.pop() !== pair[c]) return false;
  }
  return st.length === 0;
}
```

### Min stack (O(1) getMin)

Keep a parallel stack of minima (or encode min into values). Each push records `min(x, currentMin)`.

**Kotlin**

```kotlin
class MinStack {
    private val vals = ArrayDeque<Int>()
    private val mins = ArrayDeque<Int>()

    fun push(x: Int) {
        vals.addLast(x)
        mins.addLast(if (mins.isEmpty()) x else minOf(x, mins.last()))
    }
    fun pop() { vals.removeLast(); mins.removeLast() }
    fun top() = vals.last()
    fun getMin() = mins.last()
}
```

**Swift**

```swift
final class MinStack {
    private var vals: [Int] = []
    private var mins: [Int] = []
    func push(_ x: Int) {
        vals.append(x)
        mins.append(mins.last.map { min(x, $0) } ?? x)
    }
    func pop() { vals.removeLast(); mins.removeLast() }
    func top() -> Int { vals.last! }
    func getMin() -> Int { mins.last! }
}
```

**Dart**

```dart
class MinStack {
  final _vals = <int>[];
  final _mins = <int>[];
  void push(int x) {
    _vals.add(x);
    _mins.add(_mins.isEmpty ? x : (x < _mins.last ? x : _mins.last));
  }
  void pop() { _vals.removeLast(); _mins.removeLast(); }
  int top() => _vals.last;
  int getMin() => _mins.last;
}
```

**TypeScript**

```typescript
class MinStack {
  private vals: number[] = [];
  private mins: number[] = [];
  push(x: number): void {
    this.vals.push(x);
    const m = this.mins.length ? Math.min(x, this.mins[this.mins.length - 1]) : x;
    this.mins.push(m);
  }
  pop(): void { this.vals.pop(); this.mins.pop(); }
  top(): number { return this.vals[this.vals.length - 1]; }
  getMin(): number { return this.mins[this.mins.length - 1]; }
}
```

## Common mistakes

1. **Using index 0 as the top** on an array — every push/pop shifts; use the end.
2. **Forgetting to clear redo** on a new edit — redo then reapplies stale history.
3. **Deep recursion instead of an explicit stack** — silent production crashes on large inputs.
4. **Holding Activity/Fragment/View references inside undo commands** — leaks; store IDs or value snapshots.
5. **Assuming `Stack` class on Android** — `java.util.Stack` is synchronized and legacy; prefer `ArrayDeque`.

## Self-Check

**5.1** Why must `push`/`pop`/`peek` be O(1) for a navigation back-stack under rapid gesture spam?

**5.2** How does `UINavigationController` relate to a stack? What is the “top”?

**5.3** Sketch undo/redo with two stacks after the sequence: type A, type B, undo, type C.

**5.4** When should you replace recursion with an explicit stack on mobile?

**5.5** Why is `ArrayDeque` preferred over `java.util.Stack` on Android?

*(Answers: Appendix D.)*

## Practice

1. **Valid parentheses** — [solutions/ch05](../../solutions/ch05/README.md#p1-valid-parentheses)
2. **Min stack** (`push`/`pop`/`top`/`getMin` all O(1)) — [solutions/ch05](../../solutions/ch05/README.md#p2-min-stack)
3. **Simplify absolute path** (Unix-style `/a/./b/../../c/`) — [solutions/ch05](../../solutions/ch05/README.md#p3-simplify-absolute-path)

Next: [Chapter 6 — Queues and Deques](06-queues-deques.md) — FIFO, sliding windows, and request queues.
