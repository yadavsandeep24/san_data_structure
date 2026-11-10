# Chapter 36 — Heaps, Tries & Greedy (12-Day Plan Gap-Closer)

Part X closes the gaps between this book and the public **12-day DSA plan** (120 problems): it holds only the plan problems no earlier chapter solved. The rest already live elsewhere — the [Chapter 24 question bank](../part-vii/24-interview-questions.md), the [Chapter 27 hard bank](../part-viii/27-hard-drill-bank.md), and the topic chapters [17 greedy](../part-v/17-greedy-thinking.md), [18 heaps](../part-vi/18-heaps-priority-queues.md), [19 DP](../part-vi/19-dynamic-programming.md), [20 graphs](../part-vi/20-graphs-advanced.md) and [10 tries](../part-iii/10-trees-practical.md). Same mobile framing habit as the rest of the book; statements are rewritten, not copied.

Companion index: [`solutions/ch36/README.md`](../../solutions/ch36/README.md)

---

## How to use

| Plan day | Problems in this chapter | Same-day problems already in the book |
|----------|--------------------------|---------------------------------------|
| **Day 8** | Q1 Kth Largest Element in a Stream; Q2 K Closest Points to Origin | Last Stone Weight ([Ch 18](../part-vi/18-heaps-priority-queues.md)), Find Median from Data Stream ([Ch 27 Q14](../part-viii/27-hard-drill-bank.md)); the tree half of Day 8 is in [Ch 35](35-linked-lists-trees.md) |
| **Day 9** | Q3 Task Scheduler; Q4 Design Add and Search Words Data Structure; Q5 Word Search II; Q6 Jump Game II; Q7 Gas Station; Q8 Hand of Straights | Task Scheduler variant ([Ch 25](../part-vii/25-mini-projects.md)), Implement Trie ([Ch 24](../part-vii/24-interview-questions.md)), Jump Game ([Ch 17](../part-v/17-greedy-thinking.md)), Maximum Subarray ([Ch 32](32-arrays-hashing-matrix.md)), Design Twitter ([Ch 27 Q10](../part-viii/27-hard-drill-bank.md)) |
| **Day 10** | Q9 Merge Triplets to Form Target Triplet; Q10 Partition Labels; Q11 Valid Parenthesis String | Number of Islands ([Ch 22](../part-vi/22-bits-matrix.md)) — the graph half of Day 10 continues in [Ch 37](37-graphs-dynamic-programming.md) |

Protocol is the Chapter 27 one: restate + edges (3–5 min), say **time/space before code**, code the happy path, then edges. **Languages:** every problem is shown in Kotlin (Android/KMP), Swift (iOS), Dart (Flutter) and TypeScript (React Native), in that order, with the same names and behaviour. Dart snippets assume `import 'dart:math';` for `max`/`min`. Swift and Dart have no built-in priority queue, so Q1 defines a small binary `Heap<T>` in Swift, Dart and TypeScript, and Q2 reuses it. Work a plan day's problems together — they share one technique.

---

## Q1. Kth Largest Element in a Stream (Live Leaderboard Cutoff)

**Topic:** Heap (bounded min-heap)

**Plan day:** Day 8

**Statement**

A game screen shows the score you must beat to enter the top `k`. Build a class constructed with `k` and the scores so far; each `add(score)` records a new score and returns the current k-th largest. Example: `k = 3`, initial `[4, 5, 8, 2]`, then adding `3, 5, 10, 9, 4` returns `4, 5, 5, 8, 8`. At least `k` scores exist whenever `add` returns.

**Approach**

Brute force: keep everything and sort on every `add`, O(n log n) per call.

Keep a **min-heap of size k**. Its root is the smallest of the top k, which is exactly the k-th largest. Push the new value; if the heap grows past k, pop the root.

**Complexity:** Time O(log k) per `add` (O(n log k) to build), Space O(k)

### Kotlin

```kotlin
import java.util.PriorityQueue

class KthLargest(private val k: Int, nums: IntArray) {
    private val heap = PriorityQueue<Int>() // min-heap holding the top k

    init {
        nums.forEach { add(it) }
    }

    fun add(v: Int): Int {
        heap.offer(v)
        if (heap.size > k) heap.poll()
        return heap.peek()
    }
}
```

### Swift

```swift
struct Heap<T> {
    private var items: [T] = []
    private let less: (T, T) -> Bool
    init(_ less: @escaping (T, T) -> Bool) { self.less = less }

    var count: Int { items.count }
    var peek: T? { items.first }

    mutating func push(_ x: T) {
        items.append(x)
        var i = items.count - 1
        while i > 0 {
            let p = (i - 1) / 2
            if !less(items[i], items[p]) { break }
            items.swapAt(i, p)
            i = p
        }
    }

    @discardableResult
    mutating func pop() -> T? {
        guard !items.isEmpty else { return nil }
        items.swapAt(0, items.count - 1)
        let top = items.removeLast()
        var i = 0
        while true {
            let l = 2 * i + 1, r = l + 1
            var m = i
            if l < items.count && less(items[l], items[m]) { m = l }
            if r < items.count && less(items[r], items[m]) { m = r }
            if m == i { break }
            items.swapAt(i, m)
            i = m
        }
        return top
    }
}

final class KthLargest {
    private let k: Int
    private var heap = Heap<Int>(<) // min-heap of the top k

    init(_ k: Int, _ nums: [Int]) {
        self.k = k
        for x in nums { _ = add(x) }
    }

    func add(_ val: Int) -> Int {
        heap.push(val)
        if heap.count > k { heap.pop() }
        return heap.peek ?? Int.min
    }
}
```

### Dart

```dart
class Heap<T> {
  final List<T> _items = [];
  final bool Function(T a, T b) _less;
  Heap(this._less);

  int get length => _items.length;
  T? get peek => _items.isEmpty ? null : _items.first;

  void push(T x) {
    _items.add(x);
    var i = _items.length - 1;
    while (i > 0) {
      final p = (i - 1) >> 1;
      if (!_less(_items[i], _items[p])) break;
      _swap(i, p);
      i = p;
    }
  }

  T? pop() {
    if (_items.isEmpty) return null;
    _swap(0, _items.length - 1);
    final top = _items.removeLast();
    var i = 0;
    while (true) {
      final l = 2 * i + 1, r = l + 1;
      var m = i;
      if (l < _items.length && _less(_items[l], _items[m])) m = l;
      if (r < _items.length && _less(_items[r], _items[m])) m = r;
      if (m == i) break;
      _swap(i, m);
      i = m;
    }
    return top;
  }

  void _swap(int i, int j) {
    final t = _items[i];
    _items[i] = _items[j];
    _items[j] = t;
  }
}

class KthLargest {
  final int k;
  final _heap = Heap<int>((a, b) => a < b); // min-heap of the top k

  KthLargest(this.k, List<int> nums) {
    for (final x in nums) {
      add(x);
    }
  }

  int add(int val) {
    _heap.push(val);
    if (_heap.length > k) _heap.pop();
    return _heap.peek ?? -1;
  }
}
```

### TypeScript

```typescript
class Heap<T> {
  private items: T[] = [];
  private less: (a: T, b: T) => boolean;
  constructor(less: (a: T, b: T) => boolean) {
    this.less = less;
  }
  get size(): number {
    return this.items.length;
  }
  peek(): T | undefined {
    return this.items[0];
  }
  push(x: T): void {
    const a = this.items;
    a.push(x);
    let i = a.length - 1;
    while (i > 0) {
      const p = (i - 1) >> 1;
      if (!this.less(a[i], a[p])) break;
      [a[i], a[p]] = [a[p], a[i]];
      i = p;
    }
  }
  pop(): T | undefined {
    const a = this.items;
    if (a.length === 0) return undefined;
    const top = a[0];
    const last = a.pop()!;
    if (a.length > 0) {
      a[0] = last;
      let i = 0;
      for (;;) {
        const l = 2 * i + 1, r = l + 1;
        let m = i;
        if (l < a.length && this.less(a[l], a[m])) m = l;
        if (r < a.length && this.less(a[r], a[m])) m = r;
        if (m === i) break;
        [a[i], a[m]] = [a[m], a[i]];
        i = m;
      }
    }
    return top;
  }
}

class KthLargest {
  private k: number;
  private heap = new Heap<number>((a, b) => a < b); // min-heap of the top k
  constructor(k: number, nums: number[]) {
    this.k = k;
    for (const x of nums) this.add(x);
  }
  add(val: number): number {
    this.heap.push(val);
    if (this.heap.size > this.k) this.heap.pop();
    return this.heap.peek()!;
  }
}
```

**Mobile note:** Bounded memory no matter how long the stream runs, so it is safe to keep in a ViewModel for a live leaderboard. Post only the cutoff to the UI (`LiveData`/`StateFlow` for Views, `collectAsState` for Compose), not the heap.

---

## Q2. K Closest Points to Origin (Nearest Stores on the Map)

**Topic:** Heap (bounded max-heap)

**Plan day:** Day 8

**Statement**

Store pins are given as `[x, y]` offsets from the user (a flat local projection). Return any `k` pins closest to the origin by Euclidean distance; order does not matter. Example: `[[1,3],[-2,2]]`, `k = 1` → `[[-2,2]]`.

**Approach**

Brute force: sort all points by distance, take the first k, O(n log n).

Keep a **max-heap of size k** keyed by squared distance (no `sqrt` needed). When it exceeds k, evict the farthest. Quickselect also works in O(n) on average, but it reorders the input array.

**Complexity:** Time O(n log k), Space O(k)

### Kotlin

```kotlin
import java.util.PriorityQueue

fun kClosest(points: Array<IntArray>, k: Int): Array<IntArray> {
    fun dist(p: IntArray): Long = p[0].toLong() * p[0] + p[1].toLong() * p[1]
    val maxHeap = PriorityQueue<IntArray>(compareByDescending { dist(it) })
    for (p in points) {
        maxHeap.offer(p)
        if (maxHeap.size > k) maxHeap.poll() // drop the farthest
    }
    return maxHeap.toTypedArray()
}
```

### Swift

```swift
// uses Heap<T> from Q1
func kClosest(_ points: [[Int]], _ k: Int) -> [[Int]] {
    func dist(_ p: [Int]) -> Int { p[0] * p[0] + p[1] * p[1] }
    var heap = Heap<[Int]> { dist($0) > dist($1) } // max-heap by distance
    for p in points {
        heap.push(p)
        if heap.count > k { heap.pop() } // drop the farthest
    }
    var out: [[Int]] = []
    while let p = heap.pop() { out.append(p) }
    return out
}
```

### Dart

```dart
// uses Heap<T> from Q1
List<List<int>> kClosest(List<List<int>> points, int k) {
  int dist(List<int> p) => p[0] * p[0] + p[1] * p[1];
  final heap = Heap<List<int>>((a, b) => dist(a) > dist(b)); // max-heap by distance
  for (final p in points) {
    heap.push(p);
    if (heap.length > k) heap.pop(); // drop the farthest
  }
  final out = <List<int>>[];
  for (var p = heap.pop(); p != null; p = heap.pop()) {
    out.add(p);
  }
  return out;
}
```

### TypeScript

```typescript
// uses Heap<T> from Q1
function kClosest(points: number[][], k: number): number[][] {
  const d = (p: number[]) => p[0] * p[0] + p[1] * p[1];
  const heap = new Heap<number[]>((a, b) => d(a) > d(b)); // max-heap by distance
  for (const p of points) {
    heap.push(p);
    if (heap.size > k) heap.pop(); // drop the farthest
  }
  const out: number[][] = [];
  while (heap.size > 0) out.push(heap.pop()!);
  return out;
}
```

**Mobile note:** Real geo pins need haversine or a projected distance; the squared-distance trick holds only on a small, locally flat area. Use `Long` in Kotlin, because squared coordinates can overflow `Int`.

---

## Q3. Task Scheduler (Notification Cooldown Slots)

**Topic:** Greedy / counting

**Plan day:** Day 9

**Statement**

Push jobs are labelled `A`–`Z`. Each time slot runs one job or stays idle, and two jobs with the same label must be at least `n` slots apart. Return the fewest slots needed to run every job. Example: `AAABBB`, `n = 2` → `8` (`A B idle A B idle A B`).

**Approach**

Brute force: simulate slot by slot, each time running the available label with the most jobs left (a max-heap plus a cooldown queue), O(T log 26).

Counting formula: let `maxF` be the highest frequency and `maxCount` the number of labels that have it. The most frequent labels force `maxF - 1` frames of width `n + 1` plus one final row of `maxCount` jobs. If there are enough other jobs to fill every idle gap, there is no idle time at all, so the answer is `max(tasks.size, (maxF - 1) * (n + 1) + maxCount)`.

**Complexity:** Time O(T), Space O(1) (26 counters)

### Kotlin

```kotlin
fun leastInterval(tasks: CharArray, n: Int): Int {
    if (tasks.isEmpty()) return 0
    val freq = IntArray(26)
    for (t in tasks) freq[t - 'A']++
    val maxF = freq.max()
    val maxCount = freq.count { it == maxF }
    // (maxF - 1) full frames of width n + 1, plus a last row of the top tasks
    return maxOf(tasks.size, (maxF - 1) * (n + 1) + maxCount)
}
```

### Swift

```swift
func leastInterval(_ tasks: [Character], _ n: Int) -> Int {
    var freq = [Int](repeating: 0, count: 26)
    for t in tasks {
        guard let v = t.asciiValue, v >= 65, v <= 90 else { continue } // labels are 'A'...'Z'
        freq[Int(v) - 65] += 1
    }
    guard let maxF = freq.max(), maxF > 0 else { return 0 }
    let maxCount = freq.filter { $0 == maxF }.count
    return max(tasks.count, (maxF - 1) * (n + 1) + maxCount)
}
```

### Dart

```dart
int leastInterval(List<String> tasks, int n) {
  if (tasks.isEmpty) return 0;
  final freq = List<int>.filled(26, 0);
  for (final t in tasks) {
    freq[t.codeUnitAt(0) - 65]++;
  }
  final maxF = freq.reduce(max);
  final maxCount = freq.where((f) => f == maxF).length;
  return max(tasks.length, (maxF - 1) * (n + 1) + maxCount);
}
```

### TypeScript

```typescript
function leastInterval(tasks: string[], n: number): number {
  if (tasks.length === 0) return 0;
  const freq = new Array<number>(26).fill(0);
  for (const t of tasks) freq[t.charCodeAt(0) - 65]++;
  const maxF = Math.max(...freq);
  const maxCount = freq.filter((f) => f === maxF).length;
  return Math.max(tasks.length, (maxF - 1) * (n + 1) + maxCount);
}
```

**Mobile note:** This is the same shape as rate-limiting a category of local notifications or analytics flushes. On Android, a real scheduler is WorkManager with backoff, but the formula still tells you the lower bound on total time.

---

## Q4. Design Add and Search Words Data Structure (Wildcard Contact Search)

**Topic:** Trie + DFS

**Plan day:** Day 9

**Statement**

Support `addWord(word)` and `search(pattern)`, where the pattern may contain `.`, which matches any single letter. Words are lowercase `a`–`z`. Example: after adding `bad, dad, mad`, `search(".ad")` is `true` and `search("b..")` is `true`, but `search("pad")` is `false`.

**Approach**

Brute force: scan every stored word and compare character by character, O(W·L) per search.

Store words in a **trie**. A plain letter follows one edge. A `.` tries every child (DFS). A match succeeds only if the walk ends on a node marked `end`.

**Complexity:** Time O(L) to add; search is O(L) without dots and up to O(26^d · L) in the worst case with d dots. Space O(total letters)

### Kotlin

```kotlin
class WordDictionary {
    private class Node {
        val next = arrayOfNulls<Node>(26)
        var end = false
    }

    private val root = Node()

    fun addWord(word: String) {
        var cur = root
        for (c in word) {
            val i = c - 'a'
            cur = cur.next[i] ?: Node().also { cur.next[i] = it }
        }
        cur.end = true
    }

    fun search(word: String): Boolean = match(word, 0, root)

    private fun match(w: String, i: Int, node: Node): Boolean {
        if (i == w.length) return node.end
        val c = w[i]
        if (c != '.') {
            val nx = node.next[c - 'a'] ?: return false
            return match(w, i + 1, nx)
        }
        return node.next.any { it != null && match(w, i + 1, it) }
    }
}
```

### Swift

```swift
final class TrieNode {
    var next: [Character: TrieNode] = [:]
    var end = false
}

final class WordDictionary {
    private let root = TrieNode()

    func addWord(_ word: String) {
        var cur = root
        for c in word {
            if let nx = cur.next[c] {
                cur = nx
            } else {
                let nx = TrieNode()
                cur.next[c] = nx
                cur = nx
            }
        }
        cur.end = true
    }

    func search(_ word: String) -> Bool {
        let chars = Array(word)
        func match(_ i: Int, _ node: TrieNode) -> Bool {
            if i == chars.count { return node.end }
            if chars[i] != "." {
                guard let nx = node.next[chars[i]] else { return false }
                return match(i + 1, nx)
            }
            return node.next.values.contains { match(i + 1, $0) }
        }
        return match(0, root)
    }
}
```

### Dart

```dart
class TrieNode {
  final next = <String, TrieNode>{};
  bool end = false;
}

class WordDictionary {
  final _root = TrieNode();

  void addWord(String word) {
    var cur = _root;
    for (final c in word.split('')) {
      cur = cur.next.putIfAbsent(c, () => TrieNode());
    }
    cur.end = true;
  }

  bool search(String word) {
    bool match(int i, TrieNode node) {
      if (i == word.length) return node.end;
      final c = word[i];
      if (c != '.') {
        final nx = node.next[c];
        return nx != null && match(i + 1, nx);
      }
      return node.next.values.any((child) => match(i + 1, child));
    }

    return match(0, _root);
  }
}
```

### TypeScript

```typescript
type TrieNode = { next: Map<string, TrieNode>; end: boolean };

class WordDictionary {
  private root: TrieNode = { next: new Map(), end: false };

  addWord(word: string): void {
    let cur = this.root;
    for (const c of word) {
      let nx = cur.next.get(c);
      if (!nx) {
        nx = { next: new Map(), end: false };
        cur.next.set(c, nx);
      }
      cur = nx;
    }
    cur.end = true;
  }

  search(word: string): boolean {
    const match = (i: number, node: TrieNode): boolean => {
      if (i === word.length) return node.end;
      const c = word[i];
      if (c !== ".") {
        const nx = node.next.get(c);
        return nx !== undefined && match(i + 1, nx);
      }
      for (const child of node.next.values()) if (match(i + 1, child)) return true;
      return false;
    };
    return match(0, this.root);
  }
}
```

**Mobile note:** For type-ahead, debounce input (~150–300 ms) and run the search off the main thread (`Dispatchers.Default`). Then publish the results to a `RecyclerView` adapter or a Compose `LazyColumn`.

---

## Q5. Word Search II (Word Game Board Scan)

**Topic:** Trie + backtracking

**Plan day:** Day 9

**Statement**

Given a letter grid and a list of words, return every word that can be traced through horizontally or vertically adjacent cells, using each cell at most once per word. Order does not matter, and each word is reported once. Example: board `oaan/etae/ihkr/iflv` with `[oath, pea, eat, rain]` → `[oath, eat]`.

**Approach**

Brute force: run a separate grid DFS for each word, O(W · R·C · 4^L).

Put all the words in a **trie** and run one DFS from each cell, walking the grid and the trie together. Mark the current cell `#` while it is on the path. When a node holds a word, record it and clear it so it is reported only once. Prune as soon as the next letter has no trie edge.

**Complexity:** Time O(R·C · 4·3^(L-1)) worst case, Space O(total letters in words)

### Kotlin

```kotlin
fun findWords(board: Array<CharArray>, words: Array<String>): List<String> {
    class Node {
        val next = arrayOfNulls<Node>(26)
        var word: String? = null
    }
    val root = Node()
    for (w in words) {
        var cur = root
        for (c in w) cur = cur.next[c - 'a'] ?: Node().also { cur.next[c - 'a'] = it }
        cur.word = w
    }
    val rows = board.size
    val cols = board[0].size
    val found = mutableListOf<String>()
    fun dfs(r: Int, c: Int, parent: Node) {
        val ch = board[r][c]
        if (ch == '#') return
        val node = parent.next[ch - 'a'] ?: return
        node.word?.let { found += it; node.word = null } // report once
        board[r][c] = '#'
        if (r > 0) dfs(r - 1, c, node)
        if (r < rows - 1) dfs(r + 1, c, node)
        if (c > 0) dfs(r, c - 1, node)
        if (c < cols - 1) dfs(r, c + 1, node)
        board[r][c] = ch
    }
    for (r in 0 until rows) for (c in 0 until cols) dfs(r, c, root)
    return found
}
```

### Swift

```swift
final class WordNode {
    var next: [Character: WordNode] = [:]
    var word: String?
}

func findWords(_ board: [[Character]], _ words: [String]) -> [String] {
    let root = WordNode()
    for w in words {
        var cur = root
        for c in w {
            if let nx = cur.next[c] {
                cur = nx
            } else {
                let nx = WordNode()
                cur.next[c] = nx
                cur = nx
            }
        }
        cur.word = w
    }
    var grid = board // local copy; Swift arrays are values
    let rows = grid.count, cols = grid.first?.count ?? 0
    var found: [String] = []
    func dfs(_ r: Int, _ c: Int, _ parent: WordNode) {
        let ch = grid[r][c]
        guard let node = parent.next[ch] else { return } // '#' is never a trie edge
        if let w = node.word {
            found.append(w)
            node.word = nil // report once
        }
        grid[r][c] = "#"
        if r > 0 { dfs(r - 1, c, node) }
        if r < rows - 1 { dfs(r + 1, c, node) }
        if c > 0 { dfs(r, c - 1, node) }
        if c < cols - 1 { dfs(r, c + 1, node) }
        grid[r][c] = ch
    }
    for r in 0..<rows { for c in 0..<cols { dfs(r, c, root) } }
    return found
}
```

### Dart

```dart
class WordNode {
  final next = <String, WordNode>{};
  String? word;
}

List<String> findWords(List<List<String>> board, List<String> words) {
  final root = WordNode();
  for (final w in words) {
    var cur = root;
    for (final c in w.split('')) {
      cur = cur.next.putIfAbsent(c, () => WordNode());
    }
    cur.word = w;
  }
  final rows = board.length, cols = board[0].length;
  final found = <String>[];
  void dfs(int r, int c, WordNode parent) {
    final ch = board[r][c];
    final node = parent.next[ch]; // '#' is never a trie edge
    if (node == null) return;
    final w = node.word;
    if (w != null) {
      found.add(w);
      node.word = null; // report once
    }
    board[r][c] = '#';
    if (r > 0) dfs(r - 1, c, node);
    if (r < rows - 1) dfs(r + 1, c, node);
    if (c > 0) dfs(r, c - 1, node);
    if (c < cols - 1) dfs(r, c + 1, node);
    board[r][c] = ch;
  }

  for (var r = 0; r < rows; r++) {
    for (var c = 0; c < cols; c++) {
      dfs(r, c, root);
    }
  }
  return found;
}
```

### TypeScript

```typescript
type WNode = { next: Map<string, WNode>; word: string | null };

function findWords(board: string[][], words: string[]): string[] {
  const root: WNode = { next: new Map(), word: null };
  for (const w of words) {
    let cur = root;
    for (const c of w) {
      if (!cur.next.has(c)) cur.next.set(c, { next: new Map(), word: null });
      cur = cur.next.get(c)!;
    }
    cur.word = w;
  }
  const rows = board.length, cols = board[0].length;
  const found: string[] = [];
  const dfs = (r: number, c: number, parent: WNode): void => {
    const ch = board[r][c];
    const node = parent.next.get(ch); // '#' is never a trie edge
    if (!node) return;
    if (node.word !== null) {
      found.push(node.word);
      node.word = null; // report once
    }
    board[r][c] = "#";
    if (r > 0) dfs(r - 1, c, node);
    if (r < rows - 1) dfs(r + 1, c, node);
    if (c > 0) dfs(r, c - 1, node);
    if (c < cols - 1) dfs(r, c + 1, node);
    board[r][c] = ch;
  };
  for (let r = 0; r < rows; r++) for (let c = 0; c < cols; c++) dfs(r, c, root);
  return found;
}
```

**Mobile note:** In a word game, build the trie once when the dictionary loads (off the main thread), not on every board shuffle.

---

## Q6. Jump Game II (Fewest Deep-Link Hops)

**Topic:** Greedy (BFS by ranges)

**Plan day:** Day 9

**Statement**

Screen `i` of a flow can jump forward to any screen up to `nums[i]` steps ahead. Starting at screen 0, return the minimum number of jumps to reach the last screen. The last screen is always reachable. Example: `[2,3,1,1,4]` → `2`.

**Approach**

Brute force: DP `best[j] = min(best[i] + 1)` over all `i` that can reach `j`, O(n²).

Treat it as **implicit BFS**. `curEnd` is the furthest index reachable with the current number of jumps, and `farthest` is the furthest reachable with one more. When `i` reaches `curEnd`, you must spend a jump, so set `curEnd = farthest`.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun jump(nums: IntArray): Int {
    var jumps = 0
    var curEnd = 0   // last index reachable with `jumps` jumps
    var farthest = 0 // last index reachable with one more jump
    for (i in 0 until nums.lastIndex) {
        farthest = maxOf(farthest, i + nums[i])
        if (i == curEnd) {
            jumps++
            curEnd = farthest
        }
    }
    return jumps
}
```

### Swift

```swift
func jump(_ nums: [Int]) -> Int {
    var jumps = 0
    var curEnd = 0   // last index reachable with `jumps` jumps
    var farthest = 0 // last index reachable with one more jump
    for i in 0..<max(0, nums.count - 1) {
        farthest = max(farthest, i + nums[i])
        if i == curEnd {
            jumps += 1
            curEnd = farthest
        }
    }
    return jumps
}
```

### Dart

```dart
int jump(List<int> nums) {
  var jumps = 0;
  var curEnd = 0; // last index reachable with `jumps` jumps
  var farthest = 0; // last index reachable with one more jump
  for (var i = 0; i < nums.length - 1; i++) {
    farthest = max(farthest, i + nums[i]);
    if (i == curEnd) {
      jumps++;
      curEnd = farthest;
    }
  }
  return jumps;
}
```

### TypeScript

```typescript
function jump(nums: number[]): number {
  let jumps = 0, curEnd = 0, farthest = 0;
  for (let i = 0; i < nums.length - 1; i++) {
    farthest = Math.max(farthest, i + nums[i]);
    if (i === curEnd) {
      jumps++;
      curEnd = farthest;
    }
  }
  return jumps;
}
```

---

## Q7. Gas Station (EV Delivery Loop Start)

**Topic:** Greedy (prefix reset)

**Plan day:** Day 9

**Statement**

A delivery van runs a circular route. Stop `i` gives `gas[i]` charge, and driving from stop `i` to the next one costs `cost[i]`. The van starts empty. Return the index of a stop from which it can complete the full loop, or `-1` if there is none (if an answer exists, it is unique). Example: `gas = [1,2,3,4,5]`, `cost = [3,4,5,1,2]` → `3`.

**Approach**

Brute force: simulate from every start, O(n²).

If `sum(gas) < sum(cost)`, the answer is `-1`. Otherwise sweep once with a running tank. If the tank drops below zero at `i`, no stop from `start` to `i` can be the start (each one arrives at `i` with no more fuel than `start` did), so restart at `i + 1` with an empty tank.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun canCompleteCircuit(gas: IntArray, cost: IntArray): Int {
    var total = 0
    var tank = 0
    var start = 0
    for (i in gas.indices) {
        val diff = gas[i] - cost[i]
        total += diff
        tank += diff
        if (tank < 0) { // nothing in start..i can be the answer
            start = i + 1
            tank = 0
        }
    }
    return if (total >= 0) start else -1
}
```

### Swift

```swift
func canCompleteCircuit(_ gas: [Int], _ cost: [Int]) -> Int {
    var total = 0, tank = 0, start = 0
    for i in gas.indices {
        let diff = gas[i] - cost[i]
        total += diff
        tank += diff
        if tank < 0 { // nothing in start...i can be the answer
            start = i + 1
            tank = 0
        }
    }
    return total >= 0 ? start : -1
}
```

### Dart

```dart
int canCompleteCircuit(List<int> gas, List<int> cost) {
  var total = 0, tank = 0, start = 0;
  for (var i = 0; i < gas.length; i++) {
    final diff = gas[i] - cost[i];
    total += diff;
    tank += diff;
    if (tank < 0) { // nothing in start..i can be the answer
      start = i + 1;
      tank = 0;
    }
  }
  return total >= 0 ? start : -1;
}
```

### TypeScript

```typescript
function canCompleteCircuit(gas: number[], cost: number[]): number {
  let total = 0, tank = 0, start = 0;
  for (let i = 0; i < gas.length; i++) {
    const diff = gas[i] - cost[i];
    total += diff;
    tank += diff;
    if (tank < 0) {
      start = i + 1;
      tank = 0;
    }
  }
  return total >= 0 ? start : -1;
}
```

---

## Q8. Hand of Straights (Consecutive Ticket Batches)

**Topic:** Greedy + ordered map

**Plan day:** Day 9

**Statement**

Ticket numbers `hand` must be split into batches of exactly `groupSize` consecutive numbers, using each ticket exactly once. Return whether that is possible. Example: `[1,2,3,6,2,3,4,7,8]`, `groupSize = 3` → `true` (`123`, `234`, `678`).

**Approach**

Brute force: backtrack over which run to form next, exponential.

The **smallest remaining value must start a run**, because nothing smaller can absorb it. Count values in an ordered map, then repeatedly take the smallest key and consume `first … first+groupSize-1`, failing on any gap. The TypeScript, Swift and Dart versions walk the sorted keys once and subtract `need = count[first]` runs in bulk, which is the same greedy.

**Complexity:** Time O(n log n), Space O(n)

### Kotlin

```kotlin
import java.util.TreeMap

fun isNStraightHand(hand: IntArray, groupSize: Int): Boolean {
    if (hand.size % groupSize != 0) return false
    val count = TreeMap<Int, Int>()
    for (h in hand) count.merge(h, 1, Int::plus)
    while (count.isNotEmpty()) {
        val first = count.firstKey() // smallest card must start a group
        for (v in first until first + groupSize) {
            val c = count[v] ?: return false
            if (c == 1) count.remove(v) else count[v] = c - 1
        }
    }
    return true
}
```

### Swift

```swift
func isNStraightHand(_ hand: [Int], _ groupSize: Int) -> Bool {
    if hand.count % groupSize != 0 { return false }
    var count: [Int: Int] = [:]
    for h in hand { count[h, default: 0] += 1 }
    for first in count.keys.sorted() {
        let need = count[first] ?? 0 // groups that must start here
        if need == 0 { continue }
        for v in first..<(first + groupSize) {
            let have = count[v] ?? 0
            if have < need { return false }
            count[v] = have - need
        }
    }
    return true
}
```

### Dart

```dart
bool isNStraightHand(List<int> hand, int groupSize) {
  if (hand.length % groupSize != 0) return false;
  final count = <int, int>{};
  for (final h in hand) {
    count[h] = (count[h] ?? 0) + 1;
  }
  final keys = count.keys.toList()..sort();
  for (final first in keys) {
    final need = count[first] ?? 0; // groups that must start here
    if (need == 0) continue;
    for (var v = first; v < first + groupSize; v++) {
      final have = count[v] ?? 0;
      if (have < need) return false;
      count[v] = have - need;
    }
  }
  return true;
}
```

### TypeScript

```typescript
function isNStraightHand(hand: number[], groupSize: number): boolean {
  if (hand.length % groupSize !== 0) return false;
  const count = new Map<number, number>();
  for (const h of hand) count.set(h, (count.get(h) ?? 0) + 1);
  const keys = [...count.keys()].sort((a, b) => a - b);
  for (const first of keys) {
    const need = count.get(first)!; // groups that must start here
    if (need === 0) continue;
    for (let v = first; v < first + groupSize; v++) {
      const have = count.get(v) ?? 0;
      if (have < need) return false;
      count.set(v, have - need);
    }
  }
  return true;
}
```

---

## Q9. Merge Triplets to Form Target Triplet (Release Gate Versions)

**Topic:** Greedy (filter)

**Plan day:** Day 10

**Statement**

Each triplet is a set of minimum build numbers `[android, ios, web]` from one feature flag. Merging two triplets takes the element-wise max. Decide whether some subset of the triplets merges to exactly `target`. Example: `[[2,5,3],[1,8,4],[1,7,5]]`, target `[2,7,5]` → `true` (merge the first and third).

**Approach**

Brute force: try every subset, O(2^n).

Any triplet with a value **above** the target in some position can never be used, because max cannot go back down. Take every remaining triplet, which is safe since they cannot overshoot, and check that each of the 3 positions is matched exactly by at least one of them.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun mergeTriplets(triplets: Array<IntArray>, target: IntArray): Boolean {
    val hit = BooleanArray(3)
    for (t in triplets) {
        if (t[0] > target[0] || t[1] > target[1] || t[2] > target[2]) continue // would overshoot
        for (i in 0..2) if (t[i] == target[i]) hit[i] = true
    }
    return hit.all { it }
}
```

### Swift

```swift
func mergeTriplets(_ triplets: [[Int]], _ target: [Int]) -> Bool {
    var hit = [false, false, false]
    for t in triplets {
        if t[0] > target[0] || t[1] > target[1] || t[2] > target[2] { continue } // would overshoot
        for i in 0..<3 where t[i] == target[i] { hit[i] = true }
    }
    return hit.allSatisfy { $0 }
}
```

### Dart

```dart
bool mergeTriplets(List<List<int>> triplets, List<int> target) {
  final hit = [false, false, false];
  for (final t in triplets) {
    if (t[0] > target[0] || t[1] > target[1] || t[2] > target[2]) continue; // would overshoot
    for (var i = 0; i < 3; i++) {
      if (t[i] == target[i]) hit[i] = true;
    }
  }
  return hit.every((h) => h);
}
```

### TypeScript

```typescript
function mergeTriplets(triplets: number[][], target: number[]): boolean {
  const hit = [false, false, false];
  for (const t of triplets) {
    if (t[0] > target[0] || t[1] > target[1] || t[2] > target[2]) continue; // would overshoot
    for (let i = 0; i < 3; i++) if (t[i] === target[i]) hit[i] = true;
  }
  return hit.every(Boolean);
}
```

---

## Q10. Partition Labels (Chunking a Sync Log)

**Topic:** Greedy (last occurrence)

**Plan day:** Day 10

**Statement**

A sync log is a string of entity ids (one letter each). Split it into as many contiguous chunks as possible so that each id appears in only one chunk, and return the chunk sizes. Example: `ababcbacadefegdehijhklij` → `[9,7,8]`.

**Approach**

Brute force: for each cut point, check whether the letter sets on the two sides are disjoint, O(n²).

Record the **last index** of every letter. Sweep, stretching `end` to the last occurrence of each letter you see. When `i == end`, the chunk is closed.

**Complexity:** Time O(n), Space O(1) (26 slots)

### Kotlin

```kotlin
fun partitionLabels(s: String): List<Int> {
    val last = IntArray(26)
    for (i in s.indices) last[s[i] - 'a'] = i
    val sizes = mutableListOf<Int>()
    var start = 0
    var end = 0
    for (i in s.indices) {
        end = maxOf(end, last[s[i] - 'a'])
        if (i == end) {
            sizes += end - start + 1
            start = i + 1
        }
    }
    return sizes
}
```

### Swift

```swift
func partitionLabels(_ s: String) -> [Int] {
    let chars = Array(s)
    var last: [Character: Int] = [:]
    for (i, c) in chars.enumerated() { last[c] = i }
    var sizes: [Int] = []
    var start = 0, end = 0
    for (i, c) in chars.enumerated() {
        end = max(end, last[c] ?? i)
        if i == end {
            sizes.append(end - start + 1)
            start = i + 1
        }
    }
    return sizes
}
```

### Dart

```dart
List<int> partitionLabels(String s) {
  final last = <String, int>{};
  for (var i = 0; i < s.length; i++) {
    last[s[i]] = i;
  }
  final sizes = <int>[];
  var start = 0, end = 0;
  for (var i = 0; i < s.length; i++) {
    end = max(end, last[s[i]] ?? i);
    if (i == end) {
      sizes.add(end - start + 1);
      start = i + 1;
    }
  }
  return sizes;
}
```

### TypeScript

```typescript
function partitionLabels(s: string): number[] {
  const last = new Map<string, number>();
  for (let i = 0; i < s.length; i++) last.set(s[i], i);
  const sizes: number[] = [];
  let start = 0, end = 0;
  for (let i = 0; i < s.length; i++) {
    end = Math.max(end, last.get(s[i])!);
    if (i === end) {
      sizes.push(end - start + 1);
      start = i + 1;
    }
  }
  return sizes;
}
```

**Mobile note:** This is the same reasoning as batching an offline mutation queue so that all writes to one record land in the same upload chunk, which keeps each chunk independently retryable.

---

## Q11. Valid Parenthesis String (Template Brackets with Wildcards)

**Topic:** Greedy (range of balances)

**Plan day:** Day 10

**Statement**

A string contains `(`, `)` and `*`, where `*` can stand for `(`, `)` or nothing. Return whether some choice makes the brackets balanced. Example: `(*))` → `true`, `*(` → `false`.

**Approach**

Brute force: try all 3^k replacements of the stars.

Track the **range** `[lo, hi]` of possible open counts. `(` raises both, `)` lowers both, and `*` lowers `lo` and raises `hi`. If `hi < 0`, there are too many `)`. Clamp `lo` at 0, because a negative balance is never a valid choice. The string is valid if `lo == 0` at the end.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun checkValidString(s: String): Boolean {
    var lo = 0 // fewest open brackets possible
    var hi = 0 // most open brackets possible
    for (c in s) {
        when (c) {
            '(' -> { lo++; hi++ }
            ')' -> { lo--; hi-- }
            else -> { lo--; hi++ } // '*' as ')' or '('
        }
        if (hi < 0) return false
        if (lo < 0) lo = 0
    }
    return lo == 0
}
```

### Swift

```swift
func checkValidString(_ s: String) -> Bool {
    var lo = 0, hi = 0 // range of possible open-bracket counts
    for c in s {
        switch c {
        case "(": lo += 1; hi += 1
        case ")": lo -= 1; hi -= 1
        default: lo -= 1; hi += 1 // '*'
        }
        if hi < 0 { return false }
        if lo < 0 { lo = 0 }
    }
    return lo == 0
}
```

### Dart

```dart
bool checkValidString(String s) {
  var lo = 0, hi = 0; // range of possible open-bracket counts
  for (final c in s.split('')) {
    if (c == '(') {
      lo++;
      hi++;
    } else if (c == ')') {
      lo--;
      hi--;
    } else { // '*'
      lo--;
      hi++;
    }
    if (hi < 0) return false;
    if (lo < 0) lo = 0;
  }
  return lo == 0;
}
```

### TypeScript

```typescript
function checkValidString(s: string): boolean {
  let lo = 0, hi = 0; // range of possible open-bracket counts
  for (const c of s) {
    if (c === "(") { lo++; hi++; }
    else if (c === ")") { lo--; hi--; }
    else { lo--; hi++; } // '*'
    if (hi < 0) return false;
    if (lo < 0) lo = 0;
  }
  return lo === 0;
}
```

---

## Drill checklist (say aloud)

1. Name the plan day's pattern before coding (heap bound, trie walk, greedy invariant, BFS layer, DP state).  
2. Complexity **before** code.  
3. For DP: state, transition, base case, iteration order — in that order.  
4. One mobile sentence: main thread, memory bound, or recursion depth.  
5. Edges: empty input, single element, all-equal values, unreachable target.

Previous: [Chapter 35 — Linked Lists & Trees](35-linked-lists-trees.md) · Next: [Chapter 37 — Graphs & Dynamic Programming](37-graphs-dynamic-programming.md) · Index: [`solutions/ch36`](../../solutions/ch36/README.md).
