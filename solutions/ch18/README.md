# Chapter 18 — Model Solutions

Model solutions for Chapter 18 practice problems. Each names the pattern, states complexity, lists edge cases, and adds a short mobile note.

Problems are defined in [`book/part-vi/18-heaps-priority-queues.md`](../../book/part-vi/18-heaps-priority-queues.md).

---

## P1: Kth largest element

### Approach

Maintain a min-heap of size at most `k`. For each number, push; if size exceeds `k`, pop the smallest. The heap root is the kth largest among all elements seen.

Alternative: full sort O(n log n) — fine for tiny n; heap wins when k ≪ n.

### Complexity

- Time: O(n log k)
- Space: O(k)

### Edge cases

- `k == 1` → maximum
- `k == n` → minimum
- Duplicates
- Negatives

### Mobile note

Top scores / “kth hottest search” without sorting the full analytics array on device. Prefer server-side Top-K when n is huge; on device keep k small (10–100).

### Kotlin

```kotlin
fun findKthLargest(nums: IntArray, k: Int): Int {
    val pq = java.util.PriorityQueue<Int>() // min-heap
    for (x in nums) {
        pq.offer(x)
        if (pq.size > k) pq.poll()
    }
    return pq.peek()
}
```

### Swift

```swift
func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
    var heap = MinHeap()
    for x in nums {
        heap.push(x)
        if heap.count > k { _ = heap.pop() }
    }
    return heap.peek!
}

struct MinHeap {
    private var a: [Int] = []
    var count: Int { a.count }
    var peek: Int? { a.first }
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

### Dart

```dart
import 'package:collection/collection.dart';

int findKthLargest(List<int> nums, int k) {
  final pq = HeapPriorityQueue<int>();
  for (final x in nums) {
    pq.add(x);
    if (pq.length > k) pq.removeFirst();
  }
  return pq.first;
}
```

Manual Dart min-heap (no package):

```dart
int findKthLargestManual(List<int> nums, int k) {
  final h = <int>[];
  void siftUp(int i) {
    while (i > 0) {
      final p = (i - 1) ~/ 2;
      if (h[i] >= h[p]) break;
      final t = h[i];
      h[i] = h[p];
      h[p] = t;
      i = p;
    }
  }
  void siftDown(int i) {
    for (;;) {
      var best = i;
      final l = 2 * i + 1, r = l + 1;
      if (l < h.length && h[l] < h[best]) best = l;
      if (r < h.length && h[r] < h[best]) best = r;
      if (best == i) break;
      final t = h[i];
      h[i] = h[best];
      h[best] = t;
      i = best;
    }
  }
  for (final x in nums) {
    h.add(x);
    siftUp(h.length - 1);
    if (h.length > k) {
      h[0] = h.removeLast();
      if (h.isNotEmpty) siftDown(0);
    }
  }
  return h.first;
}
```

### TypeScript

```typescript
class MinHeap {
  private a: number[] = [];
  get size() { return this.a.length; }
  peek(): number { return this.a[0]; }
  push(x: number) {
    this.a.push(x);
    this.siftUp(this.a.length - 1);
  }
  pop(): number {
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
      if (a[i] >= a[p]) break;
      [a[i], a[p]] = [a[p], a[i]];
      i = p;
    }
  }
  private siftDown(i: number) {
    const a = this.a;
    for (;;) {
      let best = i;
      const l = i * 2 + 1, r = l + 1;
      if (l < a.length && a[l] < a[best]) best = l;
      if (r < a.length && a[r] < a[best]) best = r;
      if (best === i) break;
      [a[i], a[best]] = [a[best], a[i]];
      i = best;
    }
  }
}

function findKthLargest(nums: number[], k: number): number {
  const h = new MinHeap();
  for (const x of nums) {
    h.push(x);
    if (h.size > k) h.pop();
  }
  return h.peek();
}
```

---

## P2: Top K frequent

### Approach

Count frequencies in a hash map O(n). Push `(freq, value)` into a min-heap keyed by frequency, capped at size k (pop least frequent when over capacity). Remaining heap values are the top k frequent. Order among ties is unspecified unless you add a tie-break.

### Complexity

- Time: O(n log k)
- Space: O(n) for counts + O(k) heap

### Edge cases

- All unique → any k elements
- One value dominates
- k equals number of distinct keys
- Ties in frequency — define policy if UI needs determinism (e.g. larger value first)

### Mobile note

“Top searched terms this session” on device. Cap k; do not sort the entire frequency map on every keystroke — update counts incrementally and refresh Top-K on a debounce.

### Kotlin

```kotlin
fun topKFrequent(nums: IntArray, k: Int): IntArray {
    val freq = HashMap<Int, Int>()
    for (x in nums) freq[x] = (freq[x] ?: 0) + 1
    val pq = java.util.PriorityQueue<IntArray> { a, b -> a[0] - b[0] } // [freq, value]
    for ((v, f) in freq) {
        pq.offer(intArrayOf(f, v))
        if (pq.size > k) pq.poll()
    }
    return IntArray(pq.size) { pq.poll()[1] }
}
```

### Swift

```swift
func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
    var freq: [Int: Int] = [:]
    for x in nums { freq[x, default: 0] += 1 }
    var heap = MinHeapPair() // min by freq
    for (v, f) in freq {
        heap.push(f, v)
        if heap.count > k { _ = heap.pop() }
    }
    var out: [Int] = []
    while let p = heap.pop() { out.append(p.value) }
    return out
}

struct MinHeapPair {
    struct Node { var freq: Int; var value: Int }
    private var a: [Node] = []
    var count: Int { a.count }
    mutating func push(_ freq: Int, _ value: Int) {
        a.append(Node(freq: freq, value: value)); siftUp(a.count - 1)
    }
    mutating func pop() -> Node? {
        guard let first = a.first else { return nil }
        a[0] = a.last!; a.removeLast()
        if !a.isEmpty { siftDown(0) }
        return first
    }
    private mutating func siftUp(_ i: Int) {
        var i = i
        while i > 0 {
            let p = (i - 1) / 2
            if a[i].freq >= a[p].freq { break }
            a.swapAt(i, p); i = p
        }
    }
    private mutating func siftDown(_ i: Int) {
        var i = i
        while true {
            var best = i
            let l = 2 * i + 1, r = l + 1
            if l < a.count && a[l].freq < a[best].freq { best = l }
            if r < a.count && a[r].freq < a[best].freq { best = r }
            if best == i { break }
            a.swapAt(i, best); i = best
        }
    }
}
```

### Dart

```dart
List<int> topKFrequent(List<int> nums, int k) {
  final freq = <int, int>{};
  for (final x in nums) {
    freq[x] = (freq[x] ?? 0) + 1;
  }
  final h = <List<int>>[]; // [freq, value]
  void siftUp(int i) {
    while (i > 0) {
      final p = (i - 1) ~/ 2;
      if (h[i][0] >= h[p][0]) break;
      final t = h[i];
      h[i] = h[p];
      h[p] = t;
      i = p;
    }
  }
  void siftDown(int i) {
    for (;;) {
      var best = i;
      final l = 2 * i + 1, r = l + 1;
      if (l < h.length && h[l][0] < h[best][0]) best = l;
      if (r < h.length && h[r][0] < h[best][0]) best = r;
      if (best == i) break;
      final t = h[i];
      h[i] = h[best];
      h[best] = t;
      i = best;
    }
  }
  freq.forEach((v, f) {
    h.add([f, v]);
    siftUp(h.length - 1);
    if (h.length > k) {
      h[0] = h.removeLast();
      if (h.isNotEmpty) siftDown(0);
    }
  });
  return h.map((e) => e[1]).toList();
}
```

### TypeScript

```typescript
function topKFrequent(nums: number[], k: number): number[] {
  const freq = new Map<number, number>();
  for (const x of nums) freq.set(x, (freq.get(x) ?? 0) + 1);
  const h: [number, number][] = []; // [freq, value]
  const siftUp = (i: number) => {
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (h[i][0] >= h[p][0]) break;
      [h[i], h[p]] = [h[p], h[i]];
      i = p;
    }
  };
  const siftDown = (i: number) => {
    for (;;) {
      let best = i;
      const l = i * 2 + 1, r = l + 1;
      if (l < h.length && h[l][0] < h[best][0]) best = l;
      if (r < h.length && h[r][0] < h[best][0]) best = r;
      if (best === i) break;
      [h[i], h[best]] = [h[best], h[i]];
      i = best;
    }
  };
  for (const [v, f] of freq) {
    h.push([f, v]);
    siftUp(h.length - 1);
    if (h.length > k) {
      h[0] = h.pop()!;
      if (h.length) siftDown(0);
    }
  }
  return h.map((e) => e[1]);
}
```

---

## P3: Last stone weight

### Approach

Simulate with a max-heap: while at least two stones remain, pop two heaviest `x >= y`; if `x != y`, push `x - y`. Return the last stone or 0.

### Complexity

- Time: O(n log n)
- Space: O(n)

### Edge cases

- One stone → that weight
- Empty → 0
- All equal pairs smash to nothing → 0
- Two stones

### Mobile note

Toy combat / merge simulation. In production game loops, prefer a binary heap over re-sorting the array each smash.

### Kotlin

```kotlin
fun lastStoneWeight(stones: IntArray): Int {
    val pq = java.util.PriorityQueue<Int>(compareByDescending { it })
    for (s in stones) pq.offer(s)
    while (pq.size > 1) {
        val x = pq.poll()
        val y = pq.poll()
        if (x != y) pq.offer(x - y)
    }
    return if (pq.isEmpty()) 0 else pq.peek()
}
```

### Swift

```swift
func lastStoneWeight(_ stones: [Int]) -> Int {
    var h = MaxHeap()
    for s in stones { h.push(s) }
    while h.count > 1 {
        let x = h.pop()!
        let y = h.pop()!
        if x != y { h.push(x - y) }
    }
    return h.pop() ?? 0
}

struct MaxHeap {
    private var a: [Int] = []
    var count: Int { a.count }
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
            if a[i] <= a[p] { break }
            a.swapAt(i, p); i = p
        }
    }
    private mutating func siftDown(_ i: Int) {
        var i = i
        while true {
            var best = i
            let l = 2 * i + 1, r = l + 1
            if l < a.count && a[l] > a[best] { best = l }
            if r < a.count && a[r] > a[best] { best = r }
            if best == i { break }
            a.swapAt(i, best); i = best
        }
    }
}
```

### Dart

```dart
int lastStoneWeight(List<int> stones) {
  final h = <int>[];
  void siftUp(int i) {
    while (i > 0) {
      final p = (i - 1) ~/ 2;
      if (h[i] <= h[p]) break;
      final t = h[i];
      h[i] = h[p];
      h[p] = t;
      i = p;
    }
  }
  void siftDown(int i) {
    for (;;) {
      var best = i;
      final l = 2 * i + 1, r = l + 1;
      if (l < h.length && h[l] > h[best]) best = l;
      if (r < h.length && h[r] > h[best]) best = r;
      if (best == i) break;
      final t = h[i];
      h[i] = h[best];
      h[best] = t;
      i = best;
    }
  }
  void push(int x) {
    h.add(x);
    siftUp(h.length - 1);
  }
  int pop() {
    final top = h.first;
    h[0] = h.removeLast();
    if (h.isNotEmpty) siftDown(0);
    return top;
  }
  for (final s in stones) {
    push(s);
  }
  while (h.length > 1) {
    final x = pop();
    final y = pop();
    if (x != y) push(x - y);
  }
  return h.isEmpty ? 0 : h.first;
}
```

### TypeScript

```typescript
class MaxHeap {
  private a: number[] = [];
  get size() { return this.a.length; }
  push(x: number) {
    this.a.push(x);
    this.siftUp(this.a.length - 1);
  }
  pop(): number {
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
      if (a[i] <= a[p]) break;
      [a[i], a[p]] = [a[p], a[i]];
      i = p;
    }
  }
  private siftDown(i: number) {
    const a = this.a;
    for (;;) {
      let best = i;
      const l = i * 2 + 1, r = l + 1;
      if (l < a.length && a[l] > a[best]) best = l;
      if (r < a.length && a[r] > a[best]) best = r;
      if (best === i) break;
      [a[i], a[best]] = [a[best], a[i]];
      i = best;
    }
  }
}

function lastStoneWeight(stones: number[]): number {
  const h = new MaxHeap();
  for (const s of stones) h.push(s);
  while (h.size > 1) {
    const x = h.pop();
    const y = h.pop();
    if (x !== y) h.push(x - y);
  }
  return h.size ? h.pop() : 0;
}
```
