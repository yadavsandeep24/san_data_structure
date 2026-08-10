# Chapter 6 — Model Solutions

## P1: Queue with two stacks

### Approach

Maintain `inbound` (enqueue target) and `outbound` (dequeue source). `push` always goes to inbound. `pop`/`peek` ensure outbound is non-empty by pouring all inbound elements into outbound (reversing order) when needed. Each element moves at most twice ⇒ amortized O(1).

### Complexity

- Amortized time: O(1) per operation
- Worst single `pop`: O(n) when pouring
- Space: O(n)

### Edge cases

- `pop`/`peek` on empty — define throw vs null
- Alternating push/pop — pouring happens rarely; still correct
- Single-element thrash — still amortized fine

### Mobile note

Handy interview answer and a fine teaching model. In production Kotlin/Dart/TS prefer native deques; on Swift the head-index queue from Chapter 6 is clearer for real ingest loops.

### Kotlin

```kotlin
class MyQueue {
    private val inbound = ArrayDeque<Int>()
    private val outbound = ArrayDeque<Int>()

    fun push(x: Int) = inbound.addLast(x)

    fun pop(): Int {
        move()
        return outbound.removeLast()
    }

    fun peek(): Int {
        move()
        return outbound.last()
    }

    fun empty(): Boolean = inbound.isEmpty() && outbound.isEmpty()

    private fun move() {
        if (outbound.isEmpty()) {
            while (inbound.isNotEmpty()) outbound.addLast(inbound.removeLast())
        }
    }
}
```

### Swift

```swift
final class MyQueue {
    private var inbound: [Int] = []
    private var outbound: [Int] = []

    func push(_ x: Int) { inbound.append(x) }

    func pop() -> Int {
        move()
        return outbound.removeLast()
    }

    func peek() -> Int {
        move()
        return outbound.last!
    }

    func empty() -> Bool { inbound.isEmpty && outbound.isEmpty }

    private func move() {
        if outbound.isEmpty {
            while let v = inbound.popLast() { outbound.append(v) }
        }
    }
}
```

### Dart

```dart
class MyQueue {
  final _inbound = <int>[];
  final _outbound = <int>[];

  void push(int x) => _inbound.add(x);

  int pop() {
    _move();
    return _outbound.removeLast();
  }

  int peek() {
    _move();
    return _outbound.last;
  }

  bool empty() => _inbound.isEmpty && _outbound.isEmpty;

  void _move() {
    if (_outbound.isEmpty) {
      while (_inbound.isNotEmpty) {
        _outbound.add(_inbound.removeLast());
      }
    }
  }
}
```

### TypeScript

```typescript
class MyQueue {
  private inbound: number[] = [];
  private outbound: number[] = [];

  push(x: number): void { this.inbound.push(x); }

  pop(): number {
    this.move();
    return this.outbound.pop()!;
  }

  peek(): number {
    this.move();
    return this.outbound[this.outbound.length - 1];
  }

  empty(): boolean { return !this.inbound.length && !this.outbound.length; }

  private move(): void {
    if (!this.outbound.length) {
      while (this.inbound.length) this.outbound.push(this.inbound.pop()!);
    }
  }
}
```

---

## P2: Sliding window maximum / level-order

### Approach (sliding window maximum)

Deque stores indices with values in strictly decreasing order. For each index `i`: drop front indices `< i-k+1`; drop back indices whose values `≤ nums[i]`; push `i`. When `i ≥ k-1`, front value is the window max.

### Approach (level-order BFS preview)

Queue starts with root. While non-empty, drain `size` nodes for the current level into a list; enqueue children. Produces `List<List<Int>>` by depth.

### Complexity

- Sliding window: O(n) time, O(k) space
- Level order: O(n) time, O(w) space (w = max width)

### Edge cases

- `k == 1` → result equals input
- `k == n` → single max
- Empty tree → empty list
- Skewed tree → queue size stays small; depth equals n

### Mobile note

Sliding max over the last N frame times is a cheap jank detector. Level-order mirrors “layout this UI tree layer by layer” without recursion depth risk.

### Kotlin — sliding window

```kotlin
fun maxSlidingWindow(nums: IntArray, k: Int): IntArray {
    if (nums.isEmpty() || k <= 0) return intArrayOf()
    val dq = ArrayDeque<Int>()
    val res = IntArray(nums.size - k + 1)
    for (i in nums.indices) {
        while (dq.isNotEmpty() && dq.first() <= i - k) dq.removeFirst()
        while (dq.isNotEmpty() && nums[dq.last()] <= nums[i]) dq.removeLast()
        dq.addLast(i)
        if (i >= k - 1) res[i - k + 1] = nums[dq.first()]
    }
    return res
}
```

### Swift — sliding window

```swift
func maxSlidingWindow(_ nums: [Int], _ k: Int) -> [Int] {
    guard !nums.isEmpty, k > 0 else { return [] }
    var dq: [Int] = [], head = 0, res: [Int] = []
    for i in nums.indices {
        while head < dq.count && dq[head] <= i - k { head += 1 }
        while head < dq.count && nums[dq[dq.count - 1]] <= nums[i] { dq.removeLast() }
        dq.append(i)
        if i >= k - 1 { res.append(nums[dq[head]]) }
    }
    return res
}
```

### Dart — sliding window

```dart
import 'dart:collection';

List<int> maxSlidingWindow(List<int> nums, int k) {
  if (nums.isEmpty || k <= 0) return [];
  final dq = Queue<int>();
  final res = <int>[];
  for (var i = 0; i < nums.length; i++) {
    while (dq.isNotEmpty && dq.first <= i - k) dq.removeFirst();
    while (dq.isNotEmpty && nums[dq.last] <= nums[i]) dq.removeLast();
    dq.addLast(i);
    if (i >= k - 1) res.add(nums[dq.first]);
  }
  return res;
}
```

### TypeScript — sliding window

```typescript
function maxSlidingWindow(nums: number[], k: number): number[] {
  if (!nums.length || k <= 0) return [];
  const dq: number[] = [];
  let head = 0;
  const res: number[] = [];
  for (let i = 0; i < nums.length; i++) {
    while (head < dq.length && dq[head] <= i - k) head++;
    while (head < dq.length && nums[dq[dq.length - 1]] <= nums[i]) dq.pop();
    dq.push(i);
    if (i >= k - 1) res.push(nums[dq[head]]);
  }
  return res;
}
```

### Kotlin — level order (BFS preview)

```kotlin
class TreeNode(var value: Int) {
    var left: TreeNode? = null
    var right: TreeNode? = null
}

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

### Swift / Dart / TypeScript — level order

Same loop: queue + `for size` drain. Swift uses `Array` + head index or accepts `removeFirst` for tree width; Dart uses `Queue`; TypeScript uses the Chapter 6 `Queue<T>` class.

```typescript
function levelOrder(root: TreeNode | null): number[][] {
  if (!root) return [];
  const res: number[][] = [];
  const q = new Queue<TreeNode>();
  q.enqueue(root);
  while (q.size) {
    const level: number[] = [];
    const size = q.size;
    for (let i = 0; i < size; i++) {
      const node = q.dequeue()!;
      level.push(node.value);
      if (node.left) q.enqueue(node.left);
      if (node.right) q.enqueue(node.right);
    }
    res.push(level);
  }
  return res;
}
```

---

## P3: Bounded request queue with drop policy

### Approach

Keep a FIFO of pending requests and a counter (or set) of in-flight work up to `maxInFlight`. On submit: if pending+in-flight at `capacity`, apply drop policy, else enqueue. When a slot frees, dequeue and start. Policies: `dropNewest`, `dropOldest`, or suspend (backpressure) when supported by the host language.

### Complexity

- Submit / complete: O(1) with a proper deque
- Space: O(capacity)

### Edge cases

- Capacity 0 → always drop
- Complete after cancel — ignore stale callbacks (generation token)
- Duplicate request IDs — define replace vs reject
- Threading — mutate queue on one serial executor / actor

### Mobile note

Match Android `WorkManager` constraints and iOS background transfer limits. Log drops with reason codes; otherwise “missing uploads” become support tickets.

**Production note:** do not invoke `execute` / network callbacks **while holding** `@Synchronized` or `NSLock` — if the callback re-enters the queue or blocks, you risk deadlock or ANR. Dequeue under lock, then dispatch work on a serial executor / `Task` / coroutine outside the critical section.

### Kotlin

```kotlin
enum class DropPolicy { DropNewest, DropOldest }

class BoundedRequestQueue(
    private val capacity: Int,
    private val maxInFlight: Int,
    private val policy: DropPolicy,
    private val execute: (Request) -> Unit,
) {
    data class Request(val id: String, val payload: ByteArray)

    private val pending = ArrayDeque<Request>()
    private var inFlight = 0

    @Synchronized
    fun submit(req: Request): Boolean {
        if (pending.size + inFlight >= capacity) {
            when (policy) {
                DropPolicy.DropNewest -> return false
                DropPolicy.DropOldest -> if (pending.isNotEmpty()) pending.removeFirst() else return false
            }
        }
        pending.addLast(req)
        pump()
        return true
    }

    @Synchronized
    fun onComplete() {
        inFlight = (inFlight - 1).coerceAtLeast(0)
        pump()
    }

    private fun pump() {
        while (inFlight < maxInFlight && pending.isNotEmpty()) {
            val next = pending.removeFirst()
            inFlight++
            execute(next)
        }
    }
}
```

### Swift

```swift
enum DropPolicy { case dropNewest, dropOldest }

final class BoundedRequestQueue {
    struct Request { let id: String; let payload: Data }

    private let capacity: Int
    private let maxInFlight: Int
    private let policy: DropPolicy
    private let execute: (Request) -> Void
    private var pending = Queue<Request>()
    private var inFlight = 0
    private let lock = NSLock()

    init(capacity: Int, maxInFlight: Int, policy: DropPolicy, execute: @escaping (Request) -> Void) {
        self.capacity = capacity
        self.maxInFlight = maxInFlight
        self.policy = policy
        self.execute = execute
    }

    @discardableResult
    func submit(_ req: Request) -> Bool {
        lock.lock(); defer { lock.unlock() }
        if pendingCount() + inFlight >= capacity {
            switch policy {
            case .dropNewest: return false
            case .dropOldest:
                guard pending.dequeue() != nil else { return false }
            }
        }
        pending.enqueue(req)
        pump()
        return true
    }

    func onComplete() {
        lock.lock(); defer { lock.unlock() }
        inFlight = max(0, inFlight - 1)
        pump()
    }

    private func pendingCount() -> Int {
        // Track size alongside Queue in production; omitted for brevity in sketch.
        // Prefer storing `var size` on Queue.
        0 // replace with real size field
    }

    private func pump() {
        while inFlight < maxInFlight, let next = pending.dequeue() {
            inFlight += 1
            execute(next)
        }
    }
}
```

### Dart

```dart
import 'dart:collection';

enum DropPolicy { dropNewest, dropOldest }

class Request {
  Request(this.id, this.payload);
  final String id;
  final List<int> payload;
}

class BoundedRequestQueue {
  BoundedRequestQueue({
    required this.capacity,
    required this.maxInFlight,
    required this.policy,
    required this.execute,
  });

  final int capacity;
  final int maxInFlight;
  final DropPolicy policy;
  final void Function(Request) execute;

  final _pending = Queue<Request>();
  var _inFlight = 0;

  bool submit(Request req) {
    if (_pending.length + _inFlight >= capacity) {
      switch (policy) {
        case DropPolicy.dropNewest:
          return false;
        case DropPolicy.dropOldest:
          if (_pending.isEmpty) return false;
          _pending.removeFirst();
      }
    }
    _pending.addLast(req);
    _pump();
    return true;
  }

  void onComplete() {
    if (_inFlight > 0) _inFlight--;
    _pump();
  }

  void _pump() {
    while (_inFlight < maxInFlight && _pending.isNotEmpty) {
      final next = _pending.removeFirst();
      _inFlight++;
      execute(next);
    }
  }
}
```

### TypeScript

```typescript
type DropPolicy = 'dropNewest' | 'dropOldest';

interface Request { id: string; payload: Uint8Array }

class BoundedRequestQueue {
  private pending = new Queue<Request>();
  private inFlight = 0;

  constructor(
    private capacity: number,
    private maxInFlight: number,
    private policy: DropPolicy,
    private execute: (req: Request) => void,
  ) {}

  submit(req: Request): boolean {
    if (this.pending.size + this.inFlight >= this.capacity) {
      if (this.policy === 'dropNewest') return false;
      if (!this.pending.dequeue()) return false;
    }
    this.pending.enqueue(req);
    this.pump();
    return true;
  }

  onComplete(): void {
    this.inFlight = Math.max(0, this.inFlight - 1);
    this.pump();
  }

  private pump(): void {
    while (this.inFlight < this.maxInFlight && this.pending.size) {
      const next = this.pending.dequeue()!;
      this.inFlight++;
      this.execute(next);
    }
  }
}
```

Use the Chapter 6 `Queue<T>` (head-index) so `dequeue` stays O(1). Wire `onComplete` from your HTTP client callback; hop to the main/JS thread only for UI, not for queue mutation if a worker owns the queue.
