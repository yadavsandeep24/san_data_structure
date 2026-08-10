# Chapter 6 — Queues and Deques

## Mobile motivation

A photo uploader enqueues five images. The network layer must send them **in order**, retry failures, and never block the UI thread. That is a **queue**: First-In, First-Out (FIFO). A chat sync pipeline, WorkManager chain, URLSession task ordering, and “process events on the main looper” are all queues wearing platform clothes.

A **deque** (double-ended queue) lets you push/pop at both ends in O(1). Sliding-window maximum, undo buffers that drop from the oldest side, and BFS level-order traversal all lean on deques. Get the backing structure wrong — especially `Array.removeFirst()` in a hot loop — and a “simple” queue becomes O(n²) under load.

## FIFO and deque basics

| Structure | Insert | Remove | Use |
|-----------|--------|--------|-----|
| Queue | rear | front | Task scheduling, BFS, request pipelines |
| Stack | top | top | LIFO (Chapter 5) |
| Deque | either end | either end | Sliding windows, steals, dual-ended buffers |

### The Array.removeFirst trap

On Kotlin `MutableList`, Swift `Array`, Dart `List`, and JS `Array`, removing index 0 shifts every element — **O(n)**. Doing that per network event is O(n²). Fix:

| Language | Prefer |
|----------|--------|
| Kotlin | `ArrayDeque` — `addLast` / `removeFirst` |
| Swift | Circular buffer or array + `head` index (see below) |
| Dart | `Queue` from `dart:collection`, or `ListQueue` |
| TypeScript | Ring buffer, or head-index pattern; avoid `shift()` in hot paths |

## Complexity at a glance

| Operation | ArrayDeque / proper queue | Array + removeFirst / shift |
|-----------|---------------------------|-----------------------------|
| enqueue | O(1) amortized | O(1) amortized at end |
| dequeue | O(1) | **O(n)** |
| peek front | O(1) | O(1) |
| enqueue front (deque) | O(1) | O(n) |

## Platform bridges

| Platform | Queue you already use |
|----------|------------------------|
| **Android** | `Handler` / `Looper` message queue; `WorkManager` work chain; `ArrayDeque` in app code; coroutines channels as rendezvous queues. |
| **iOS** | GCD `DispatchQueue` (serial = FIFO tasks); `OperationQueue`; RunLoop sources; URLSession delegate callbacks serialized. |
| **Flutter** | Event loop / microtask queue; `Stream` buffers; isolate message ports. |
| **React Native** | JS event loop + native bridge message queue; interaction manager; batched updates. |

### Network request queue (design sketch)

Bound the in-flight set (e.g. max 4). Pending requests sit in a FIFO. On completion, dequeue the next. Drop policies when full:

- **Drop-newest** — reject the incoming request (protect in-flight work).
- **Drop-oldest** — discard the head pending item (favor freshness — good for location pings).
- **Block / backpressure** — suspend producers (coroutines / async) until space opens.

Always document which policy you chose; “silent drop” without metrics is a production footgun.

## Implementations (four languages)

### Kotlin — ArrayDeque as queue

```kotlin
val q = ArrayDeque<String>()
q.addLast("a")          // enqueue
q.addLast("b")
val front = q.removeFirst() // "a"
```

### Swift — queue with head index

Swift’s `Array` has no amortized O(1) remove-first. Use a head index and compact occasionally:

```swift
struct Queue<Element> {
    private var storage: [Element] = []
    private var head = 0

    var isEmpty: Bool { head >= storage.count }

    mutating func enqueue(_ x: Element) {
        storage.append(x)
    }

    mutating func dequeue() -> Element? {
        guard head < storage.count else { return nil }
        defer {
            head += 1
            if head > 32 && head * 2 >= storage.count {
                storage.removeFirst(head)
                head = 0
            }
        }
        return storage[head]
    }

    func peek() -> Element? {
        head < storage.count ? storage[head] : nil
    }
}
```

### Dart — Queue

```dart
import 'dart:collection';

final q = Queue<String>();
q.addLast('a');
q.addLast('b');
final front = q.removeFirst(); // a
```

### TypeScript — head-index pattern

```typescript
class Queue<T> {
  private data: T[] = [];
  private head = 0;

  enqueue(x: T): void { this.data.push(x); }

  dequeue(): T | undefined {
    if (this.head >= this.data.length) return undefined;
    const v = this.data[this.head++];
    if (this.head > 32 && this.head * 2 >= this.data.length) {
      this.data = this.data.slice(this.head);
      this.head = 0;
    }
    return v;
  }

  peek(): T | undefined {
    return this.head < this.data.length ? this.data[this.head] : undefined;
  }

  get size(): number { return this.data.length - this.head; }
}
```

## Classic patterns

### Queue with two stacks

Inbound stack for enqueue; outbound stack for dequeue. When outbound is empty, pour inbound into outbound (reverses order). Amortized O(1) per op.

```kotlin
class MyQueue {
    private val `in` = ArrayDeque<Int>()
    private val out = ArrayDeque<Int>()

    fun push(x: Int) = `in`.addLast(x)

    fun pop(): Int {
        move()
        return out.removeLast()
    }

    fun peek(): Int {
        move()
        return out.last()
    }

    fun empty() = `in`.isEmpty() && out.isEmpty()

    private fun move() {
        if (out.isEmpty()) while (`in`.isNotEmpty()) out.addLast(`in`.removeLast())
    }
}
```

### Sliding window maximum (deque of indices)

Maintain a deque of indices with values in **decreasing** order. The front is the window max. Evict indices outside the window; evict from the back while the new value is larger. Use a real deque or a **head index** — never `shift`/`removeAt(0)` in the hot path if you claim O(n).

**Kotlin**

```kotlin
fun maxSlidingWindow(nums: IntArray, k: Int): IntArray {
    if (nums.isEmpty() || k == 0) return intArrayOf()
    val dq = ArrayDeque<Int>() // indices
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

**Swift**

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

**Dart**

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

**TypeScript**

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

**Mobile note:** Useful for “max FPS / max RSS over last N samples” dashboards — O(n) total, not O(nk).

### BFS preview — binary tree level order

A queue drives breadth-first traversal: enqueue root; while not empty, dequeue, visit, enqueue children. Full tree chapters come later; the queue mechanic is identical to “process this layer of UI nodes.”

## Common mistakes

1. **`list.removeAt(0)` / `array.shift()`** in a service worker loop — quadratic.
2. **Unbounded request queues** — memory climbs until the OS jetsams your app.
3. **Touching UI from a background queue** without hopping to main/looper/RunLoop.
4. **Assuming GCD concurrent queues are FIFO for completion order** — submission order ≠ completion order; only **serial** queues give strict FIFO *execution*. Concurrent queues may start work in order but completions interleave; synchronize shared state.
5. **Using a stack where FIFO is required** — retries appear in reverse order; users see the newest upload finish first while older ones starve.

## Self-Check

**6.1** Why is `Array.removeFirst()` dangerous inside a 10k-event ingest loop?

**6.2** How does Android’s `Looper` relate to a queue?

**6.3** Explain amortized O(1) for a two-stack queue.

**6.4** In sliding window maximum, what does the front of the deque always represent?

**6.5** When would you choose drop-oldest over drop-newest for a location upload queue?

*(Answers: Appendix D.)*

## Practice

1. **Implement a queue with two stacks** — [solutions/ch06](../../solutions/ch06/README.md#p1-queue-with-two-stacks)
2. **Sliding window maximum** *(or binary tree level-order as BFS preview)* — [solutions/ch06](../../solutions/ch06/README.md#p2-sliding-window-maximum--level-order)
3. **Design a bounded request queue with a drop policy** — [solutions/ch06](../../solutions/ch06/README.md#p3-bounded-request-queue)

Back: [Chapter 5 — Stacks](05-stacks.md) · Next: [Chapter 7 — Hash Tables](../part-iii/07-hash-tables.md)
