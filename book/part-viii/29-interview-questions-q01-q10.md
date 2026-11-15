# Chapter 29 — Interview Questions, Mobile-Dev Focused — Q1–Q10

Part of [Chapter 29 — Interview Questions, Mobile-Dev Focused](29-interview-questions.md). Read the overview first for the timing rules and strategy.

---

## Q1. Two Sum (Cart SKU Pair)

**Topic:** Arrays / hashing

**Statement**

Given `nums` and `target`, return indices of two distinct elements that sum to `target`. Mobile framing: two line prices that complete a promo total.

**Approach**

One pass. Map `value → index`. For each `x`, look up `target - x`; else store `x`.

**Complexity:** Time O(n), Space O(n)

**Mobile note:** Same pattern as “find existing cart line for complementary SKU” without nested loops on the main thread.

### Kotlin

```kotlin
fun twoSum(nums: IntArray, target: Int): IntArray {
    val seen = HashMap<Int, Int>()
    for (i in nums.indices) {
        val j = seen[target - nums[i]]
        if (j != null) return intArrayOf(j, i)
        seen[nums[i]] = i
    }
    return intArrayOf()
}
```

### Swift

```swift
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var seen: [Int: Int] = [:]
    for (i, x) in nums.enumerated() {
        if let j = seen[target - x] { return [j, i] }
        seen[x] = i
    }
    return []
}
```

### Dart

```dart
List<int> twoSum(List<int> nums, int target) {
  final seen = <int, int>{};
  for (var i = 0; i < nums.length; i++) {
    final j = seen[target - nums[i]];
    if (j != null) return [j, i];
    seen[nums[i]] = i;
  }
  return [];
}
```

### TypeScript

```typescript
function twoSum(nums: number[], target: number): number[] {
  const seen = new Map<number, number>();
  for (let i = 0; i < nums.length; i++) {
    const j = seen.get(target - nums[i]);
    if (j !== undefined) return [j, i];
    seen.set(nums[i], i);
  }
  return [];
}
```

## Q2. Contains Duplicate (Dedupe Guard)

**Topic:** Arrays / hashing

**Statement**

Return whether any value appears ≥ 2 times. Framing: prevent double-enqueue of the same download id.

**Approach**

Insert into a hash set; if insert fails / already present → true.

**Complexity:** Time O(n), Space O(n)

### Kotlin

```kotlin
fun containsDuplicate(nums: IntArray): Boolean {
    val s = HashSet<Int>()
    for (x in nums) if (!s.add(x)) return true
    return false
}
```

### Swift

```swift
func containsDuplicate(_ nums: [Int]) -> Bool {
    var s = Set<Int>()
    for x in nums { if !s.insert(x).inserted { return true } }
    return false
}
```

### Dart

```dart
bool containsDuplicate(List<int> nums) {
  final s = <int>{};
  for (final x in nums) {
    if (!s.add(x)) return true;
  }
  return false;
}
```

### TypeScript

```typescript
function containsDuplicate(nums: number[]): boolean {
  const s = new Set<number>();
  for (const x of nums) {
    if (s.has(x)) return true;
    s.add(x);
  }
  return false;
}
```

## Q3. Group Anagrams (Facet Grouping)

**Topic:** Arrays / hashing

**Statement**

Group strings that are anagrams. Framing: group search facet tokens that share a signature.

**Approach**

Key = sorted characters (or count tuple). Map key → list of words.

**Complexity:** Time O(n · k log k) with sort key (k = max length), Space O(n·k)

### Kotlin

```kotlin
fun groupAnagrams(strs: Array<String>): List<List<String>> {
    val m = HashMap<String, MutableList<String>>()
    for (s in strs) {
        val k = s.toCharArray().sorted().joinToString("")
        m.getOrPut(k) { mutableListOf() }.add(s)
    }
    return m.values.toList()
}
```

### Swift

```swift
func groupAnagrams(_ strs: [String]) -> [[String]] {
    var m: [String: [String]] = [:]
    for s in strs {
        let k = String(s.sorted())
        m[k, default: []].append(s)
    }
    return Array(m.values)
}
```

### Dart

```dart
List<List<String>> groupAnagrams(List<String> strs) {
  final m = <String, List<String>>{};
  for (final s in strs) {
    final k = String.fromCharCodes(s.runes.toList()..sort());
    m.putIfAbsent(k, () => []).add(s);
  }
  return m.values.toList();
}
```

### TypeScript

```typescript
function groupAnagrams(strs: string[]): string[][] {
  const m = new Map<string, string[]>();
  for (const s of strs) {
    const k = s.split("").sort().join("");
    if (!m.has(k)) m.set(k, []);
    m.get(k)!.push(s);
  }
  return [...m.values()];
}
```

## Q4. Top K Frequent Elements

**Topic:** Arrays / hashing (+ heap optional)

**Statement**

Return the k most frequent numbers. Framing: top-k error codes in a diagnostics buffer.

**Approach**

Count frequencies in a hash map. Use a size-k min-heap **or** bucket sort by frequency.

**Complexity:** Time O(n log k) heap / O(n) bucket, Space O(n)

### Kotlin

```kotlin
fun topKFrequent(nums: IntArray, k: Int): IntArray {
    val freq = HashMap<Int, Int>()
    for (x in nums) freq[x] = (freq[x] ?: 0) + 1
    val buckets = Array(nums.size + 1) { mutableListOf<Int>() }
    for ((v, f) in freq) buckets[f].add(v)
    val out = mutableListOf<Int>()
    for (f in buckets.indices.reversed()) {
        for (v in buckets[f]) {
            out.add(v)
            if (out.size == k) return out.toIntArray()
        }
    }
    return out.toIntArray()
}
```

### Swift

```swift
func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
    var freq: [Int: Int] = [:]
    for x in nums { freq[x, default: 0] += 1 }
    var buckets = Array(repeating: [Int](), count: nums.count + 1)
    for (v, f) in freq { buckets[f].append(v) }
    var out: [Int] = []
    for f in stride(from: buckets.count - 1, through: 0, by: -1) {
        for v in buckets[f] {
            out.append(v)
            if out.count == k { return out }
        }
    }
    return out
}
```

### Dart

```dart
List<int> topKFrequent(List<int> nums, int k) {
  final freq = <int, int>{};
  for (final x in nums) freq[x] = (freq[x] ?? 0) + 1;
  final buckets = List.generate(nums.length + 1, (_) => <int>[]);
  freq.forEach((v, f) => buckets[f].add(v));
  final out = <int>[];
  for (var f = buckets.length - 1; f >= 0; f--) {
    for (final v in buckets[f]) {
      out.add(v);
      if (out.length == k) return out;
    }
  }
  return out;
}
```

### TypeScript

```typescript
function topKFrequent(nums: number[], k: number): number[] {
  const freq = new Map<number, number>();
  for (const x of nums) freq.set(x, (freq.get(x) ?? 0) + 1);
  const buckets: number[][] = Array.from({ length: nums.length + 1 }, () => []);
  for (const [v, f] of freq) buckets[f].push(v);
  const out: number[] = [];
  for (let f = buckets.length - 1; f >= 0; f--) {
    for (const v of buckets[f]) {
      out.push(v);
      if (out.length === k) return out;
    }
  }
  return out;
}
```

## Q5. Subarray Sum Equals K

**Topic:** Arrays / hashing

**Statement**

Count continuous subarrays summing to `k`. Framing: count sessions whose duration deltas sum to a threshold.

**Approach**

Prefix sums + map `prefixSum → count`. For each prefix `p`, add `count[p - k]`.

**Complexity:** Time O(n), Space O(n)

### Kotlin

```kotlin
fun subarraySum(nums: IntArray, k: Int): Int {
    val freq = HashMap<Int, Int>()
    freq[0] = 1
    var sum = 0
    var ans = 0
    for (x in nums) {
        sum += x
        ans += freq[sum - k] ?: 0
        freq[sum] = (freq[sum] ?: 0) + 1
    }
    return ans
}
```

### Swift

```swift
func subarraySum(_ nums: [Int], _ k: Int) -> Int {
    var freq: [Int: Int] = [0: 1]
    var sum = 0, ans = 0
    for x in nums {
        sum += x
        ans += freq[sum - k, default: 0]
        freq[sum, default: 0] += 1
    }
    return ans
}
```

### Dart

```dart
int subarraySum(List<int> nums, int k) {
  final freq = <int, int>{0: 1};
  var sum = 0, ans = 0;
  for (final x in nums) {
    sum += x;
    ans += freq[sum - k] ?? 0;
    freq[sum] = (freq[sum] ?? 0) + 1;
  }
  return ans;
}
```

### TypeScript

```typescript
function subarraySum(nums: number[], k: number): number {
  const freq = new Map<number, number>([[0, 1]]);
  let sum = 0, ans = 0;
  for (const x of nums) {
    sum += x;
    ans += freq.get(sum - k) ?? 0;
    freq.set(sum, (freq.get(sum) ?? 0) + 1);
  }
  return ans;
}
```

## Q6. Valid Parentheses (Schema / Deep Link Path)

**Topic:** Stacks / queues

**Statement**

Given a string of `()[]{}`, decide if brackets are valid. Framing: validate a nested deep-link path template.

**Approach**

Stack opens; on close, pop must match. Empty stack at end.

**Complexity:** Time O(n), Space O(n)

### Kotlin

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

### Swift

```swift
func isValid(_ s: String) -> Bool {
    var st: [Character] = []
    let pair: [Character: Character] = [")": "(", "]": "[", "}": "{"]
    for c in s {
        if "([{".contains(c) { st.append(c) }
        else if st.isEmpty || st.removeLast() != pair[c]! { return false }
    }
    return st.isEmpty
}
```

### Dart

```dart
bool isValid(String s) {
  final st = <String>[];
  const pair = {')': '(', ']': '[', '}': '{'};
  for (final r in s.runes) {
    final c = String.fromCharCode(r);
    if ('([{'.contains(c)) st.add(c);
    else if (st.isEmpty || st.removeLast() != pair[c]) return false;
  }
  return st.isEmpty;
}
```

### TypeScript

```typescript
function isValid(s: string): boolean {
  const st: string[] = [];
  const pair: Record<string, string> = { ")": "(", "]": "[", "}": "{" };
  for (const c of s) {
    if ("([{".includes(c)) st.push(c);
    else if (!st.length || st.pop() !== pair[c]) return false;
  }
  return st.length === 0;
}
```

## Q7. Min Stack (Debug Overlay)

**Topic:** Stacks / queues

**Statement**

Design stack with `push`/`pop`/`top`/`getMin` all O(1). Framing: gesture stack that always shows current minimum z-index.

**Approach**

Store pairs `(value, minSoFar)` or dual stacks.

**Complexity:** O(1) per op, Space O(n)

### Kotlin

```kotlin
class MinStack {
    private val st = ArrayDeque<IntArray>() // [val, min]
    fun push(x: Int) {
        val m = if (st.isEmpty()) x else minOf(x, st.last()[1])
        st.addLast(intArrayOf(x, m))
    }
    fun pop() { st.removeLast() }
    fun top() = st.last()[0]
    fun getMin() = st.last()[1]
}
```

### Swift

```swift
final class MinStack {
    private var st: [(Int, Int)] = []
    func push(_ x: Int) {
        let m = st.last.map { min(x, $0.1) } ?? x
        st.append((x, m))
    }
    func pop() { st.removeLast() }
    func top() -> Int { st.last!.0 }
    func getMin() -> Int { st.last!.1 }
}
```

### Dart

```dart
class MinStack {
  final _st = <List<int>>[];
  void push(int x) {
    final m = _st.isEmpty ? x : (x < _st.last[1] ? x : _st.last[1]);
    _st.add([x, m]);
  }
  void pop() => _st.removeLast();
  int top() => _st.last[0];
  int getMin() => _st.last[1];
}
```

### TypeScript

```typescript
class MinStack {
  private st: [number, number][] = [];
  push(x: number): void {
    const m = this.st.length ? Math.min(x, this.st[this.st.length - 1][1]) : x;
    this.st.push([x, m]);
  }
  pop(): void { this.st.pop(); }
  top(): number { return this.st[this.st.length - 1][0]; }
  getMin(): number { return this.st[this.st.length - 1][1]; }
}
```

## Q8. Sliding Window Maximum (Scroll Velocity)

**Topic:** Stacks / queues

**Statement**

For array `nums` and window `k`, return max of each window. Framing: max scroll velocity in last k samples.

**Approach**

Monotonic deque of indices: values decreasing. Front is max; pop out-of-window; pop back while `nums[back] < nums[i]`.

**Complexity:** Time O(n), Space O(k)

### Kotlin

```kotlin
fun maxSlidingWindow(nums: IntArray, k: Int): IntArray {
    val dq = ArrayDeque<Int>()
    val out = IntArray(nums.size - k + 1)
    for (i in nums.indices) {
        while (dq.isNotEmpty() && dq.first() <= i - k) dq.removeFirst()
        while (dq.isNotEmpty() && nums[dq.last()] <= nums[i]) dq.removeLast()
        dq.addLast(i)
        if (i >= k - 1) out[i - k + 1] = nums[dq.first()]
    }
    return out
}
```

### Swift

```swift
func maxSlidingWindow(_ nums: [Int], _ k: Int) -> [Int] {
    var dq: [Int] = [], head = 0, out: [Int] = []
    for i in nums.indices {
        while head < dq.count && dq[head] <= i - k { head += 1 }
        while head < dq.count && nums[dq[dq.count - 1]] <= nums[i] { dq.removeLast() }
        dq.append(i)
        if i >= k - 1 { out.append(nums[dq[head]]) }
    }
    return out
}
```

### Dart

```dart
List<int> maxSlidingWindow(List<int> nums, int k) {
  final dq = <int>[];
  var head = 0;
  final out = <int>[];
  for (var i = 0; i < nums.length; i++) {
    while (head < dq.length && dq[head] <= i - k) head++;
    while (head < dq.length && nums[dq.last] <= nums[i]) dq.removeLast();
    dq.add(i);
    if (i >= k - 1) out.add(nums[dq[head]]);
  }
  return out;
}
```

### TypeScript

```typescript
function maxSlidingWindow(nums: number[], k: number): number[] {
  const dq: number[] = [];
  let head = 0;
  const out: number[] = [];
  for (let i = 0; i < nums.length; i++) {
    while (head < dq.length && dq[head] <= i - k) head++;
    while (head < dq.length && nums[dq[dq.length - 1]] <= nums[i]) dq.pop();
    dq.push(i);
    if (i >= k - 1) out.push(nums[dq[head]]);
  }
  return out;
}
```

## Q9. Recent Searches Ring Buffer

**Topic:** Stacks / queues

**Statement**

Keep the last `k` **unique** search strings in **most-recent-first insertion order** (re-adding an existing term moves it to the newest end). Framing: search screen history chips.

**Approach**

Queue for order + set for membership. On add: if already seen, remove it from the middle (or rebuild from a list) and re-append so it becomes newest; then enqueue; while size > k dequeue oldest and remove from set. (Production: doubly linked list + map, or head-index deque when order-only.)

**Complexity:** Amortized O(1) add with proper deque for capacity trims; O(k) when bumping a duplicate in an array queue

### Kotlin

```kotlin
class RecentSearches(private val k: Int) {
    private val q = ArrayDeque<String>()
    private val seen = HashSet<String>()
    fun add(term: String) {
        if (!seen.add(term)) q.remove(term) // bump existing to newest
        q.addLast(term)
        while (q.size > k) seen.remove(q.removeFirst())
    }
    fun list(): List<String> = q.toList().asReversed()
}
```

### Swift

```swift
final class RecentSearches {
    private let k: Int
    private var q: [String] = []
    private var head = 0
    private var seen = Set<String>()
    init(_ k: Int) { self.k = k }
    func add(_ term: String) {
        if seen.contains(term) {
            if let i = q[head...].firstIndex(of: term) { q.remove(at: i) }
        } else {
            seen.insert(term)
        }
        q.append(term)
        while q.count - head > k {
            seen.remove(q[head]); head += 1
        }
    }
    func list() -> [String] { Array(q[head...].reversed()) }
}
```

### Dart

```dart
class RecentSearches {
  RecentSearches(this.k);
  final int k;
  final q = <String>[];
  var head = 0;
  final seen = <String>{};
  void add(String term) {
    if (!seen.add(term)) {
      final i = q.indexOf(term, head);
      if (i >= 0) q.removeAt(i);
    }
    q.add(term);
    while (q.length - head > k) {
      seen.remove(q[head++]);
    }
  }
  List<String> list() => q.sublist(head).reversed.toList();
}
```

### TypeScript

```typescript
class RecentSearches {
  private q: string[] = [];
  private head = 0;
  private seen = new Set<string>();
  constructor(private k: number) {}
  add(term: string): void {
    if (this.seen.has(term)) {
      const i = this.q.indexOf(term, this.head);
      if (i >= 0) this.q.splice(i, 1);
    } else {
      this.seen.add(term);
    }
    this.q.push(term);
    while (this.q.length - this.head > this.k) {
      this.seen.delete(this.q[this.head++]);
    }
  }
  list(): string[] { return this.q.slice(this.head).reverse(); }
}
```

## Q10. Reverse Linked List

**Topic:** Linked lists

**Statement**

Reverse a singly linked list. Framing: reverse a breadcrumb chain for display.

**Approach**

Iterative three pointers: `prev`, `cur`, `next`.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
class ListNode(var `val`: Int, var next: ListNode? = null)
fun reverseList(head: ListNode?): ListNode? {
    var prev: ListNode? = null
    var cur = head
    while (cur != null) {
        val nxt = cur.next
        cur.next = prev
        prev = cur
        cur = nxt
    }
    return prev
}
```

### Swift

```swift
class ListNode {
    var val: Int
    var next: ListNode?
    init(_ val: Int, _ next: ListNode? = nil) { self.val = val; self.next = next }
}
func reverseList(_ head: ListNode?) -> ListNode? {
    var prev: ListNode? = nil, cur = head
    while let c = cur {
        let nxt = c.next; c.next = prev; prev = c; cur = nxt
    }
    return prev
}
```

### Dart

```dart
class ListNode {
  int val; ListNode? next;
  ListNode(this.val, [this.next]);
}
ListNode? reverseList(ListNode? head) {
  ListNode? prev;
  var cur = head;
  while (cur != null) {
    final nxt = cur.next;
    cur.next = prev;
    prev = cur;
    cur = nxt;
  }
  return prev;
}
```

### TypeScript

```typescript
class ListNode {
  val: number; next: ListNode | null;
  constructor(val = 0, next: ListNode | null = null) { this.val = val; this.next = next; }
}
function reverseList(head: ListNode | null): ListNode | null {
  let prev: ListNode | null = null, cur = head;
  while (cur) {
    const nxt = cur.next; cur.next = prev; prev = cur; cur = nxt;
  }
  return prev;
}
```

---

Previous: [Chapter 29 — Interview Questions, Mobile-Dev Focused](29-interview-questions.md) · Next: [Chapter 29 — Interview Questions, Mobile-Dev Focused — Q11–Q20](29-interview-questions-q11-q20.md) · Solutions: [`solutions/ch29`](../../solutions/ch29/README.md)
