# Chapter 18 — Heaps and Priority Queues

## Mobile motivation

You need the top 10 trending posts, the next highest-priority download, or the soonest calendar alarm — not a fully sorted list. Sorting everything costs O(n log n) and allocates heavily. A **binary heap** (priority queue) gives you “best so far” in O(log n) per insert/pop and O(1) peek — perfect for Top-K, merge-k streams, and scheduling on a battery-conscious device.

## Min heap vs max heap

A **binary heap** is a complete binary tree stored in an array where each parent is ≤ children (**min-heap**) or ≥ children (**max-heap**).

| Variant | Peek | Pop | Use |
|---------|------|-----|-----|
| Min-heap | Smallest | Remove smallest | Dijkstra distances, earliest deadline, “kth largest” with size-k min-heap |
| Max-heap | Largest | Remove largest | Next highest score, “last stone” smash simulations |

Priority queue ADT: `push` / `offer`, `pop` / `poll`, `peek`, optionally `remove`.

## Array indexing trick

Store heap in `a[0..size)` (0-based):

| Relation | Index |
|----------|-------|
| Parent of `i` | `(i - 1) / 2` |
| Left child | `2i + 1` |
| Right child | `2i + 2` |

1-based heaps use parent `i/2`, children `2i` and `2i+1` — pick one convention and stick to it.

### Bubble up (sift up)

After insert at the end: while node beats parent, swap upward. O(log n).

### Sink (sift down)

After removing root (swap last into root, shrink): while a child beats node, swap with the better child. O(log n).

```text
push(x):
  a[size++] = x
  bubbleUp(size - 1)

pop():
  root = a[0]
  a[0] = a[--size]
  sink(0)
  return root
```

## Language realities

| Language | What you use |
|----------|--------------|
| **Kotlin** | `PriorityQueue` (min-heap by default; pass `compareByDescending` for max) |
| **Swift** | No heap in stdlib — sketch your own or use a package; CFBinaryHeap is legacy/awkward |
| **Dart** | No stdlib heap — use a package (`collection` PriorityQueue) or manual binary heap |
| **TypeScript** | No stdlib — implement a small `BinaryHeap` class (below) |

### Kotlin PriorityQueue

```kotlin
val minPq = java.util.PriorityQueue<Int>()
minPq += 5; minPq += 1; minPq += 3
minPq.poll() // 1

val maxPq = java.util.PriorityQueue<Int>(compareByDescending { it })
```

### Swift min-heap sketch

```swift
struct MinHeap {
    private var a: [Int] = []
    var isEmpty: Bool { a.isEmpty }
    mutating func push(_ x: Int) {
        a.append(x); siftUp(a.count - 1)
    }
    mutating func pop() -> Int? {
        guard let first = a.first else { return nil }
        a[0] = a.last!; a.removeLast()
        if !a.isEmpty { siftDown(0) }
        return first
    }
    private mutating func siftUp(_ i: Int) {
        var i = i
        while i > 0 {
            let p = (i - 1) / 2
            if a[i] >= a[p] { break }
            a.swapAt(i, p); i = p
        }
    }
    private mutating func siftDown(_ i: Int) {
        var i = i
        while true {
            var best = i
            let l = 2 * i + 1, r = l + 1
            if l < a.count && a[l] < a[best] { best = l }
            if r < a.count && a[r] < a[best] { best = r }
            if best == i { break }
            a.swapAt(i, best); i = best
        }
    }
}
```

### Dart — package pattern or manual

With `package:collection`:

```dart
import 'package:collection/collection.dart';

final pq = HeapPriorityQueue<int>();
pq.add(5); pq.add(1);
pq.removeFirst(); // 1
```

Manual heap mirrors the Swift structure (`List<int>`, sift up/down). Prefer the package in apps; know the manual version for interviews.

### TypeScript binary heap class

Generic min-heap: pass a comparator `(a, b) => number` (negative when `a` should be above `b`). Default compares numbers.

```typescript
class MinHeap<T = number> {
  private a: T[] = [];
  constructor(private cmp: (a: T, b: T) => number = (a, b) => (a as number) - (b as number)) {}
  get size() { return this.a.length; }
  peek(): T | undefined { return this.a[0]; }
  push(x: T) {
    this.a.push(x);
    this.siftUp(this.a.length - 1);
  }
  pop(): T | undefined {
    if (!this.a.length) return undefined;
    const top = this.a[0];
    const last = this.a.pop()!;
    if (this.a.length) {
      this.a[0] = last;
      this.siftDown(0);
    }
    return top;
  }
  private siftUp(i: number) {
    const a = this.a;
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (this.cmp(a[i], a[p]) >= 0) break;
      [a[i], a[p]] = [a[p], a[i]];
      i = p;
    }
  }
  private siftDown(i: number) {
    const a = this.a;
    for (;;) {
      let best = i;
      const l = i * 2 + 1, r = l + 1;
      if (l < a.length && this.cmp(a[l], a[best]) < 0) best = l;
      if (r < a.length && this.cmp(a[r], a[best]) < 0) best = r;
      if (best === i) break;
      [a[i], a[best]] = [a[best], a[i]];
      i = best;
    }
  }
}
```

## Classic patterns

### Top-K / kth largest

Keep a **min-heap of size k**. For each number, push; if size > k, pop. Heap root is the kth largest; the heap holds the k largest elements.

Time O(n log k), space O(k) — better than sorting when k ≪ n (trending lists, “top scores”).

### Merge k sorted lists

Min-heap of current heads (value + list index + element index). Pop smallest, push that list’s next. O(N log k) for N total elements — used when merging sorted sync pages from k sources.

### Median from stream (overview)

Two heaps: max-heap for the lower half, min-heap for the upper half. Rebalance so sizes differ by at most one. Median is the mean of roots or the root of the larger half. Full code is interview-heavy; the idea powers live dashboards and adaptive bitrate heuristics.

### Last stone weight

Max-heap of stone weights; repeatedly smash two heaviest; push difference if nonzero. Continues until ≤1 stone left.

## Complexity

| Operation | Binary heap |
|-----------|-------------|
| peek | O(1) |
| push | O(log n) |
| pop | O(log n) |
| build heap from n items | O(n) |
| heap sort | O(n log n) |

## Platform bridges

| Platform | Priority in the wild |
|----------|----------------------|
| **Android** | `PriorityQueue`; JobScheduler / WorkManager constraints are richer than a single heap |
| **iOS** | `OperationQueue.queuePriority`; custom heaps for game AI / Top-K |
| **Flutter** | Event priorities rare; isolate work queues; package heaps for algorithms |
| **React Native** | JS heap class or native module; InteractionManager is not a general PQ |

## Common mistakes

1. Using a sorted array for repeated “remove min + insert” — each op O(n).
2. Forgetting Comparator equality/order consistency (Kotlin `PriorityQueue`).
3. Size-k heap for kth **largest** must be a **min**-heap (people invert this constantly).
4. Assuming Swift/Dart/TS have a stdlib heap.
5. Holding UI references inside priority items — prefer IDs + separate store.

## Self-Check

**18.1** Why store a heap in an array? Give parent/child index formulas (0-based).

**18.2** How do you find the kth largest with a size-k heap? Which heap flavor?

**18.3** What is the cost of push and pop on a binary heap?

**18.4** Why might merge-k sorted lists beat concatenating and sorting?

**18.5** Sketch median-of-stream with two heaps in two sentences.

*(Answers: Appendix D.)*

## Practice

1. **Kth largest element** — [solutions/ch18](../../solutions/ch18/README.md#p1-kth-largest-element)
2. **Top K frequent elements** — [solutions/ch18](../../solutions/ch18/README.md#p2-top-k-frequent)
3. **Last stone weight** — [solutions/ch18](../../solutions/ch18/README.md#p3-last-stone-weight)

Next: [Chapter 19 — Dynamic Programming](19-dynamic-programming.md) — memoization, tabulation, and where DP rarely appears in UI code.
