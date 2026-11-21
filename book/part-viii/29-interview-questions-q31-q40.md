# Chapter 29 — Interview Questions, Mobile-Dev Focused — Q31–Q40

Part of [Chapter 29 — Interview Questions, Mobile-Dev Focused](29-interview-questions.md). Read the overview first for the timing rules and strategy.

---

## Q31. Unique Paths

**Topic:** DP lite

**Statement**

Robot on `m×n` grid moves only right/down; count paths to end. Framing: count onboarding wizard paths with optional steps modeled as grid.

**Approach**

`dp[i][j] = dp[i-1][j] + dp[i][j-1]`; compress to 1D.

**Complexity:** Time O(mn), Space O(n)

### Kotlin

```kotlin
fun uniquePaths(m: Int, n: Int): Int {
    val dp = IntArray(n) { 1 }
    for (i in 1 until m) for (j in 1 until n) dp[j] += dp[j - 1]
    return dp[n - 1]
}
```

### Swift

```swift
func uniquePaths(_ m: Int, _ n: Int) -> Int {
    var dp = Array(repeating: 1, count: n)
    for _ in 1..<m { for j in 1..<n { dp[j] += dp[j - 1] } }
    return dp[n - 1]
}
```

### Dart

```dart
int uniquePaths(int m, int n) {
  final dp = List<int>.filled(n, 1);
  for (var i = 1; i < m; i++) {
    for (var j = 1; j < n; j++) dp[j] += dp[j - 1];
  }
  return dp[n - 1];
}
```

### TypeScript

```typescript
function uniquePaths(m: number, n: number): number {
  const dp: number[] = Array(n).fill(1);
  for (let i = 1; i < m; i++) for (let j = 1; j < n; j++) dp[j] += dp[j - 1];
  return dp[n - 1];
}
```

## Q32. First Unique Character

**Topic:** Strings

**Statement**

Index of first non-repeating character, or -1. Framing: first unique glyph for avatar color hash fallback.

**Approach**

Count frequencies; second pass find first with count 1.

**Complexity:** Time O(n), Space O(Σ)

### Kotlin

```kotlin
fun firstUniqChar(s: String): Int {
    val freq = HashMap<Char, Int>()
    for (c in s) freq[c] = (freq[c] ?: 0) + 1
    for (i in s.indices) if (freq[s[i]] == 1) return i
    return -1
}
```

### Swift

```swift
func firstUniqChar(_ s: String) -> Int {
    let chars = Array(s)
    var freq: [Character: Int] = [:]
    for c in chars { freq[c, default: 0] += 1 }
    for (i, c) in chars.enumerated() where freq[c] == 1 { return i }
    return -1
}
```

### Dart

```dart
int firstUniqChar(String s) {
  final freq = <String, int>{};
  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    freq[c] = (freq[c] ?? 0) + 1;
  }
  for (var i = 0; i < s.length; i++) if (freq[s[i]] == 1) return i;
  return -1;
}
```

### TypeScript

```typescript
function firstUniqChar(s: string): number {
  const freq = new Map<string, number>();
  for (let i = 0; i < s.length; i++) {
    const c = s[i];
    freq.set(c, (freq.get(c) ?? 0) + 1);
  }
  for (let i = 0; i < s.length; i++) if (freq.get(s[i]) === 1) return i;
  return -1;
}
```

## Q33. Longest Substring Without Repeating Characters

**Topic:** Strings

**Statement**

Length of longest substring with all unique chars. Framing: max unique-character window in a search query for analytics.

**Approach**

Sliding window + last-seen index map; advance `left` past duplicates.

**Complexity:** Time O(n), Space O(Σ)

### Kotlin

```kotlin
fun lengthOfLongestSubstring(s: String): Int {
    val last = HashMap<Char, Int>()
    var left = 0; var best = 0
    for (i in s.indices) {
        val c = s[i]
        val prev = last[c]
        if (prev != null && prev >= left) left = prev + 1
        last[c] = i
        best = maxOf(best, i - left + 1)
    }
    return best
}
```

### Swift

```swift
func lengthOfLongestSubstring(_ s: String) -> Int {
    let chars = Array(s)
    var last: [Character: Int] = [:]
    var left = 0, best = 0
    for (i, c) in chars.enumerated() {
        if let p = last[c], p >= left { left = p + 1 }
        last[c] = i
        best = max(best, i - left + 1)
    }
    return best
}
```

### Dart

```dart
int lengthOfLongestSubstring(String s) {
  final last = <String, int>{};
  var left = 0, best = 0;
  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    final prev = last[c];
    if (prev != null && prev >= left) left = prev + 1;
    last[c] = i;
    if (i - left + 1 > best) best = i - left + 1;
  }
  return best;
}
```

### TypeScript

```typescript
function lengthOfLongestSubstring(s: string): number {
  const last = new Map<string, number>();
  let left = 0, best = 0;
  for (let i = 0; i < s.length; i++) {
    const c = s[i];
    const prev = last.get(c);
    if (prev !== undefined && prev >= left) left = prev + 1;
    last.set(c, i);
    best = Math.max(best, i - left + 1);
  }
  return best;
}
```

## Q34. Reverse Words in a String

**Topic:** Strings

**Statement**

Reverse word order; trim / collapse spaces. Framing: flip RTL preview of a multi-word title.

**Approach**

Split on whitespace; reverse tokens; join with single spaces. Or two-pointer reverse whole then each word.

**Complexity:** Time O(n), Space O(n)

### Kotlin

```kotlin
fun reverseWords(s: String): String =
    s.trim().split(Regex("\\s+")).reversed().joinToString(" ")
```

### Swift

```swift
func reverseWords(_ s: String) -> String {
    s.split(whereSeparator: \.isWhitespace).reversed().joined(separator: " ")
}
```

### Dart

```dart
String reverseWords(String s) =>
    s.trim().split(RegExp(r'\s+')).reversed.join(' ');
```

### TypeScript

```typescript
function reverseWords(s: string): string {
  return s.trim().split(/\s+/).reverse().join(" ");
}
```

## Q35. Implement Trie (Autocomplete Core)

**Topic:** Strings

**Statement**

`insert` / `search` / `startsWith`. Framing: contact typeahead index.

**Approach**

Node with map/array of children + `end` flag.

**Complexity:** O(L) per op

### Kotlin

```kotlin
class Trie {
    private class Node { val next = HashMap<Char, Node>(); var end = false }
    private val root = Node()
    fun insert(word: String) {
        var n = root
        for (c in word) n = n.next.getOrPut(c) { Node() }
        n.end = true
    }
    fun search(word: String): Boolean {
        var n: Node? = root
        for (c in word) { n = n!!.next[c] ?: return false }
        return n!!.end
    }
    fun startsWith(prefix: String): Boolean {
        var n: Node? = root
        for (c in prefix) { n = n!!.next[c] ?: return false }
        return true
    }
}
```

### Swift

```swift
final class Trie {
    private class Node { var next: [Character: Node] = [:]; var end = false }
    private let root = Node()
    func insert(_ word: String) {
        var n = root
        for c in word { n = n.next[c] ?? { let x = Node(); n.next[c] = x; return x }() }
        n.end = true
    }
    func search(_ word: String) -> Bool {
        var n: Node? = root
        for c in word { guard let nx = n?.next[c] else { return false }; n = nx }
        return n?.end ?? false
    }
    func startsWith(_ prefix: String) -> Bool {
        var n: Node? = root
        for c in prefix { guard let nx = n?.next[c] else { return false }; n = nx }
        return true
    }
}
```

### Dart

```dart
class _Node {
  final next = <String, _Node>{};
  var end = false;
}

class Trie {
  final _root = _Node();
  void insert(String word) {
    var n = _root;
    for (var i = 0; i < word.length; i++) {
      n = n.next.putIfAbsent(word[i], _Node.new);
    }
    n.end = true;
  }
  bool search(String word) => _walk(word)?.end ?? false;
  bool startsWith(String prefix) => _walk(prefix) != null;
  _Node? _walk(String s) {
    _Node? n = _root;
    for (var i = 0; i < s.length && n != null; i++) n = n.next[s[i]];
    return n;
  }
}
```

### TypeScript

```typescript
class TrieNode {
  next = new Map<string, TrieNode>();
  end = false;
}
class Trie {
  private root = new TrieNode();
  insert(word: string): void {
    let n = this.root;
    for (const c of word) {
      let nx = n.next.get(c);
      if (!nx) { nx = new TrieNode(); n.next.set(c, nx); }
      n = nx;
    }
    n.end = true;
  }
  search(word: string): boolean { return this.walk(word)?.end ?? false; }
  startsWith(prefix: string): boolean { return this.walk(prefix) !== null; }
  private walk(s: string): TrieNode | null {
    let n: TrieNode | undefined = this.root;
    for (const c of s) { n = n.next.get(c); if (!n) return null; }
    return n;
  }
}
```

## Q36. LRU Cache

**Topic:** Concurrency / design

**Statement**

Design LRU cache with O(1) `get`/`put` and capacity eviction. Framing: decoded image memory cache.

**Approach**

Hash map + doubly linked list (or access-order LinkedHashMap). Move to head on get/put; evict tail.

**Complexity:** O(1) per op average

### Kotlin

```kotlin
class LRUCache(private val capacity: Int) {
    private class Node(val key: Int, var value: Int) {
        var prev: Node? = null; var next: Node? = null
    }
    private val map = HashMap<Int, Node>()
    private val head = Node(0, 0)
    private val tail = Node(0, 0)
    init { head.next = tail; tail.prev = head }
    private fun remove(n: Node) { n.prev!!.next = n.next; n.next!!.prev = n.prev }
    private fun addFront(n: Node) {
        n.next = head.next; n.prev = head
        head.next!!.prev = n; head.next = n
    }
    fun get(key: Int): Int {
        val n = map[key] ?: return -1
        remove(n); addFront(n); return n.value
    }
    fun put(key: Int, value: Int) {
        map[key]?.let { remove(it); map.remove(key) }
        val n = Node(key, value); addFront(n); map[key] = n
        if (map.size > capacity) {
            val lru = tail.prev!!; remove(lru); map.remove(lru.key)
        }
    }
}
```

### Swift

```swift
final class LRUCache {
    private final class Node {
        let key: Int; var value: Int
        var prev: Node?; var next: Node?
        init(_ key: Int, _ value: Int) { self.key = key; self.value = value }
    }
    private let capacity: Int
    private var map: [Int: Node] = [:]
    private let head = Node(0, 0), tail = Node(0, 0)
    init(_ capacity: Int) {
        self.capacity = capacity
        head.next = tail; tail.prev = head
    }
    private func remove(_ n: Node) { n.prev?.next = n.next; n.next?.prev = n.prev }
    private func addFront(_ n: Node) {
        n.next = head.next; n.prev = head
        head.next?.prev = n; head.next = n
    }
    func get(_ key: Int) -> Int {
        guard let n = map[key] else { return -1 }
        remove(n); addFront(n); return n.value
    }
    func put(_ key: Int, _ value: Int) {
        if let n = map[key] { remove(n); map.removeValue(forKey: key) }
        let n = Node(key, value); addFront(n); map[key] = n
        if map.count > capacity, let lru = tail.prev {
            remove(lru); map.removeValue(forKey: lru.key)
        }
    }
}
```

### Dart

```dart
class _Node {
  _Node(this.key, this.value);
  final int key;
  int value;
  _Node? prev, next;
}

class LRUCache {
  LRUCache(this.capacity) { head.next = tail; tail.prev = head; }
  final int capacity;
  final _map = <int, _Node>{};
  final head = _Node(0, 0), tail = _Node(0, 0);
  void _remove(_Node n) { n.prev!.next = n.next; n.next!.prev = n.prev; }
  void _addFront(_Node n) {
    n.next = head.next; n.prev = head;
    head.next!.prev = n; head.next = n;
  }
  int get(int key) {
    final n = _map[key];
    if (n == null) return -1;
    _remove(n); _addFront(n); return n.value;
  }
  void put(int key, int value) {
    final old = _map.remove(key);
    if (old != null) _remove(old);
    final n = _Node(key, value); _addFront(n); _map[key] = n;
    if (_map.length > capacity) {
      final lru = tail.prev!; _remove(lru); _map.remove(lru.key);
    }
  }
}
```

### TypeScript

```typescript
class LNode {
  key: number; value: number;
  prev: LNode | null = null; next: LNode | null = null;
  constructor(key: number, value: number) { this.key = key; this.value = value; }
}
class LRUCache {
  private capacity: number;
  private map = new Map<number, LNode>();
  private head = new LNode(0, 0);
  private tail = new LNode(0, 0);
  constructor(capacity: number) {
    this.capacity = capacity;
    this.head.next = this.tail; this.tail.prev = this.head;
  }
  private remove(n: LNode): void { n.prev!.next = n.next; n.next!.prev = n.prev; }
  private addFront(n: LNode): void {
    n.next = this.head.next; n.prev = this.head;
    this.head.next!.prev = n; this.head.next = n;
  }
  get(key: number): number {
    const n = this.map.get(key);
    if (!n) return -1;
    this.remove(n); this.addFront(n); return n.value;
  }
  put(key: number, value: number): void {
    const old = this.map.get(key);
    if (old) { this.remove(old); this.map.delete(key); }
    const n = new LNode(key, value); this.addFront(n); this.map.set(key, n);
    if (this.map.size > this.capacity) {
      const lru = this.tail.prev!; this.remove(lru); this.map.delete(lru.key);
    }
  }
}
```

## Q37. Thread-Safe Request Coalescer (Single-Flight)

**Topic:** Concurrency / design

**Statement**

Concurrent `load(key)` shares one in-flight fetch. Framing: image/config downloads.

**Approach**

Map key → shared Deferred/Promise; create on miss; remove in `finally`.

**Complexity:** O(1) map ops + producer cost once

### Kotlin

```kotlin
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Deferred
import kotlinx.coroutines.async
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock

// scope needs a SupervisorJob, or one failed fetch cancels every later load
class Coalescer<T>(private val scope: CoroutineScope) {
    private val mutex = Mutex()
    private val inflight = HashMap<String, Deferred<T>>()
    suspend fun load(key: String, produce: suspend () -> T): T {
        val shared = mutex.withLock {
            inflight.getOrPut(key) {
                scope.async {
                    try { produce() } finally { mutex.withLock { inflight.remove(key) } }
                }
            }
        }
        return shared.await()
    }
}
```

### Swift

```swift
// actor = serialized access to the map (Swift's "thread-safe")
actor Coalescer<T: Sendable> {
    private var inflight: [String: Task<T, Error>] = [:]
    func load(_ key: String, _ produce: @escaping @Sendable () async throws -> T) async throws -> T {
        if let existing = inflight[key] { return try await existing.value }
        let task = Task { try await produce() }
        inflight[key] = task
        defer { inflight[key] = nil }
        return try await task.value
    }
}
```

### Dart

```dart
class Coalescer<T> {
  final _inflight = <String, Future<T>>{};
  Future<T> load(String key, Future<T> Function() produce) {
    return _inflight.putIfAbsent(key, () async {
      try { return await produce(); }
      finally { _inflight.remove(key); }
    });
  }
}
```

### TypeScript

```typescript
class Coalescer<T> {
  private inflight = new Map<string, Promise<T>>();
  load(key: string, produce: () => Promise<T>): Promise<T> {
    const existing = this.inflight.get(key);
    if (existing) return existing;
    const p = produce().finally(() => this.inflight.delete(key));
    this.inflight.set(key, p);
    return p;
  }
}
```

## Q38. Token Bucket Rate Limiter

**Topic:** Concurrency / design

**Statement**

Allow average `rate` ops/sec with burst `capacity`. Framing: analytics event flush.

**Approach**

Track tokens and last refill timestamp; on `allow()`, refill elapsed×rate (capped), spend 1 token if available.

**Complexity:** O(1) per allow

### Kotlin

```kotlin
class TokenBucket(private val rate: Double, private val capacity: Double) {
    private var tokens = capacity
    private var last = System.nanoTime()
    @Synchronized fun allow(): Boolean {
        val now = System.nanoTime()
        val elapsed = (now - last) / 1e9
        last = now
        tokens = minOf(capacity, tokens + elapsed * rate)
        if (tokens < 1.0) return false
        tokens -= 1.0
        return true
    }
}
```

### Swift

```swift
final class TokenBucket {
    private let rate: Double, capacity: Double
    private var tokens: Double
    private var last = ContinuousClock.now
    private let lock = NSLock()
    init(rate: Double, capacity: Double) {
        self.rate = rate; self.capacity = capacity; self.tokens = capacity
    }
    func allow() -> Bool {
        lock.lock(); defer { lock.unlock() }
        let now = ContinuousClock.now
        let d = last.duration(to: now)
        let elapsed = Double(d.components.seconds) + Double(d.components.attoseconds) / 1e18
        last = now
        tokens = min(capacity, tokens + elapsed * rate)
        guard tokens >= 1 else { return false }
        tokens -= 1; return true
    }
}
```

### Dart

```dart
import 'dart:math' as math;

// One isolate = no shared-memory race, so no lock (unlike Kotlin/Swift)
class TokenBucket {
  TokenBucket(this.rate, this.capacity) : _tokens = capacity;
  final double rate, capacity;
  double _tokens;
  final _clock = Stopwatch()..start();
  int _lastUs = 0;
  bool allow() {
    final now = _clock.elapsedMicroseconds;
    final elapsed = (now - _lastUs) / 1e6;
    _lastUs = now;
    _tokens = math.min(capacity, _tokens + elapsed * rate);
    if (_tokens < 1.0) return false;
    _tokens -= 1.0;
    return true;
  }
}
```

### TypeScript

```typescript
// JS is single-threaded per realm: no lock needed
class TokenBucket {
  private rate: number;
  private capacity: number;
  private tokens: number;
  private last = performance.now();
  constructor(rate: number, capacity: number) {
    this.rate = rate; this.capacity = capacity; this.tokens = capacity;
  }
  allow(): boolean {
    const now = performance.now();
    const elapsed = (now - this.last) / 1000;
    this.last = now;
    this.tokens = Math.min(this.capacity, this.tokens + elapsed * this.rate);
    if (this.tokens < 1) return false;
    this.tokens -= 1;
    return true;
  }
}
```

## Q39. Navigation Back Stack

**Topic:** Concurrency / design

**Statement**

Implement `push`/`pop`/`peek`/`replace`/`popToRoot` for routes. Framing: app navigation simulator.

**Approach**

Array-backed stack; document empty-pop policy.

**Complexity:** O(1) ops; `popToRoot` O(n) clears

### Kotlin

```kotlin
class NavStack {
    private val stack = ArrayList<String>()
    fun push(route: String) { stack.add(route) }
    fun pop(): String? = stack.removeLastOrNull()
    fun peek(): String? = stack.lastOrNull()
    fun replace(route: String) {
        if (stack.isEmpty()) stack.add(route) else stack[stack.lastIndex] = route
    }
    fun popToRoot() { if (stack.isNotEmpty()) stack.subList(1, stack.size).clear() }
    fun snapshot(): List<String> = stack.toList()
}
```

### Swift

```swift
struct NavStack {
    private var stack: [String] = []
    mutating func push(_ route: String) { stack.append(route) }
    mutating func pop() -> String? { stack.popLast() }
    func peek() -> String? { stack.last }
    mutating func replace(_ route: String) {
        if stack.isEmpty { stack.append(route) } else { stack[stack.count - 1] = route }
    }
    mutating func popToRoot() { if !stack.isEmpty { stack.removeSubrange(1...) } }
    func snapshot() -> [String] { stack }
}
```

### Dart

```dart
class NavStack {
  final _stack = <String>[];
  void push(String route) => _stack.add(route);
  String? pop() => _stack.isEmpty ? null : _stack.removeLast();
  String? peek() => _stack.isEmpty ? null : _stack.last;
  void replace(String route) {
    if (_stack.isEmpty) _stack.add(route); else _stack[_stack.length - 1] = route;
  }
  void popToRoot() { if (_stack.isNotEmpty) _stack.removeRange(1, _stack.length); }
  List<String> snapshot() => List.of(_stack);
}
```

### TypeScript

```typescript
class NavStack {
  private stack: string[] = [];
  push(route: string): void { this.stack.push(route); }
  pop(): string | undefined { return this.stack.pop(); }
  peek(): string | undefined { return this.stack[this.stack.length - 1]; }
  replace(route: string): void {
    if (!this.stack.length) this.stack.push(route);
    else this.stack[this.stack.length - 1] = route;
  }
  popToRoot(): void { if (this.stack.length) this.stack.length = 1; }
  snapshot(): string[] { return this.stack.slice(); }
}
```

## Q40. Debounced Search Index Query

**Topic:** Concurrency / design

**Statement**

Design `onQuery(text)` that waits `delayMs` after the last keystroke before running an O(n) filter (or Trie suggest), cancelling stale runs. Framing: search bar.

**Approach**

Store timer/generation token; each call increments generation; only matching generation publishes results. Combine with coalescer if network.

**Complexity:** O(1) schedule; query cost once per settled query

### Kotlin

```kotlin
class DebouncedSearch(
    private val delayMs: Long,
    private val scope: kotlinx.coroutines.CoroutineScope,
    private val search: suspend (String) -> List<String>,
    private val publish: (List<String>) -> Unit,
) {
    private var gen = 0
    private var job: kotlinx.coroutines.Job? = null
    fun onQuery(text: String) {
        val my = ++gen
        job?.cancel()
        job = scope.launch {
            kotlinx.coroutines.delay(delayMs)
            if (my != gen) return@launch
            val result = search(text)
            if (my == gen) publish(result)
        }
    }
}
```

### Swift

```swift
final class DebouncedSearch {
    private let delayMs: UInt64
    private let search: (String) async -> [String]
    private let publish: ([String]) -> Void
    private var gen = 0
    private var task: Task<Void, Never>?
    init(delayMs: UInt64, search: @escaping (String) async -> [String], publish: @escaping ([String]) -> Void) {
        self.delayMs = delayMs; self.search = search; self.publish = publish
    }
    func onQuery(_ text: String) {
        gen += 1
        let my = gen
        task?.cancel()
        task = Task {
            try? await Task.sleep(nanoseconds: delayMs * 1_000_000)
            guard my == gen, !Task.isCancelled else { return }
            let result = await search(text)
            guard my == gen else { return }
            publish(result)
        }
    }
}
```

### Dart

```dart
import 'dart:async';

class DebouncedSearch {
  DebouncedSearch(this.delayMs, this.search, this.publish);
  final int delayMs;
  final Future<List<String>> Function(String) search;
  final void Function(List<String>) publish;
  var _gen = 0;
  Timer? _timer;
  void onQuery(String text) {
    final my = ++_gen;
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: delayMs), () async {
      final result = await search(text);
      if (my == _gen) publish(result);
    });
  }
}
```

### TypeScript

```typescript
class DebouncedSearch {
  private delayMs: number;
  private search: (text: string) => Promise<string[]>;
  private publish: (result: string[]) => void;
  private gen = 0;
  private timer: ReturnType<typeof setTimeout> | undefined;
  constructor(delayMs: number, search: (text: string) => Promise<string[]>, publish: (result: string[]) => void) {
    this.delayMs = delayMs; this.search = search; this.publish = publish;
  }
  onQuery(text: string): void {
    const my = ++this.gen;
    clearTimeout(this.timer);
    this.timer = setTimeout(async () => {
      const result = await this.search(text);
      if (my === this.gen) this.publish(result);
    }, this.delayMs);
  }
}
```

---

Previous: [Chapter 29 — Interview Questions, Mobile-Dev Focused — Q21–Q30](29-interview-questions-q21-q30.md) · Next: [Chapter 30 — Hard Drill Bank (Top-Company Pace)](30-hard-drill-bank.md) · Solutions: [`solutions/ch29`](../../solutions/ch29/README.md)
