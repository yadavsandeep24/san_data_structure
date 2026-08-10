# Chapter 24 — Interview Questions, Mobile-Dev Focused

This chapter is a **timed drill bank** for mobile engineers. Every problem is a standard DSA pattern wrapped in a product-shaped story (feeds, caches, navigation, coalescing). Solutions include approach, complexity, and code in **Kotlin / Swift / Dart / TypeScript** for core questions; remaining questions use two languages to keep the chapter usable.

Companion index (anchors + condensed notes): [`solutions/ch24/README.md`](../../solutions/ch24/README.md)

---

## Strategy half — how to interview like a mobile engineer

### 1. Open with constraints, not code

Say aloud: **input size**, **hot path** (UI thread vs background), **memory bound**, and **success metric** (correctness, frame budget, battery). Interviewers hiring for mobile listen for this.

### 2. Name the structure contract

Before typing: “Hash map for O(1) membership,” “deque for sliding window,” “min-heap of size k.” Wrong structure is harder to fix than a typo.

### 3. Complexity before cleverness

State time and space **before** coding. If they ask to optimize, change the structure or move work off the hot path — don’t micro-tune first.

### 4. Mobile tells that score points

- Bound caches; never “HashMap forever.”
- Prefer arrays for UI lists; sets/maps as side indexes.
- Avoid `shift` / `removeAt(0)` in hot loops.
- Mark visited when **enqueuing** in BFS.
- Prefer iterative DFS on untrusted depth.
- Single-flight / coalesce identical network keys.

### 5. Timed protocol (25–35 minutes)

| Minutes | Action |
|---------|--------|
| 0–3 | Restate + examples + edge cases |
| 3–8 | Approach + complexity + structure choice |
| 8–25 | Code happy path |
| 25–30 | Edges, tests, mobile note |
| 30–35 | Complexity recap / follow-ups |

### 6. Edge-case checklist

Empty input · single element · duplicates · negatives · overflow · disconnected graph · capacity 0 cache · concurrent double-call · UTF-16 vs grapheme · already sorted / reverse sorted.

### 7. When stuck

1. Brute force correctly (say the cost).
2. Find the repeated work → hash / sort / window / heap / DP.
3. Draw n≤6 example.
4. Offer a mobile-compromised solution (debounce, background, approximate) if exact is too hard — then return to exact.

### 8. Topic map for this bank

| Topic | Questions |
|-------|-----------|
| Arrays / hashing | Q1–Q5 |
| Stacks / queues | Q6–Q9 |
| Linked lists | Q10–Q12 |
| Trees | Q13–Q17 |
| Binary search | Q18–Q20 |
| Graphs BFS/DFS | Q21–Q24 |
| Heaps | Q25–Q27 |
| DP lite | Q28–Q31 |
| Strings | Q32–Q35 |
| Concurrency / design | Q36–Q40 |

**Language policy:** Q1–Q20 → four languages. Q21–Q40 → Kotlin+Swift *or* Dart+TypeScript (alternating), still with full approach notes.

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

## Q11. Linked List Cycle (Floyd)

**Topic:** Linked lists

**Statement**

Detect whether a list has a cycle. Framing: corrupted listener chain / retain-cycle analog in a node graph.

**Approach**

Slow/fast pointers; meet ⇒ cycle. O(1) extra memory.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun hasCycle(head: ListNode?): Boolean {
    var slow = head
    var fast = head
    while (fast?.next != null) {
        slow = slow!!.next
        fast = fast.next!!.next
        if (slow === fast) return true
    }
    return false
}
```

### Swift

```swift
func hasCycle(_ head: ListNode?) -> Bool {
    var slow = head, fast = head
    while let f = fast?.next {
        slow = slow?.next
        fast = f.next
        if slow === fast { return true }
    }
    return false
}
```

### Dart

```dart
bool hasCycle(ListNode? head) {
  var slow = head, fast = head;
  while (fast?.next != null) {
    slow = slow!.next;
    fast = fast!.next!.next;
    if (identical(slow, fast)) return true;
  }
  return false;
}
```

### TypeScript

```typescript
function hasCycle(head: ListNode | null): boolean {
  let slow = head, fast = head;
  while (fast?.next) {
    slow = slow!.next;
    fast = fast.next.next;
    if (slow === fast) return true;
  }
  return false;
}
```

## Q12. Merge Two Sorted Lists

**Topic:** Linked lists

**Statement**

Merge two sorted lists into one sorted list. Framing: merge two sorted local change logs.

**Approach**

Dummy head; always take smaller node.

**Complexity:** Time O(n+m), Space O(1) aside from links

### Kotlin

```kotlin
fun mergeTwoLists(a: ListNode?, b: ListNode?): ListNode? {
    val dummy = ListNode(0)
    var t = dummy
    var p = a; var q = b
    while (p != null && q != null) {
        if (p.`val` <= q.`val`) { t.next = p; p = p.next }
        else { t.next = q; q = q.next }
        t = t.next!!
    }
    t.next = p ?: q
    return dummy.next
}
```

### Swift

```swift
func mergeTwoLists(_ a: ListNode?, _ b: ListNode?) -> ListNode? {
    let dummy = ListNode(0); var t = dummy
    var p = a, q = b
    while let x = p, let y = q {
        if x.val <= y.val { t.next = x; p = x.next }
        else { t.next = y; q = y.next }
        t = t.next!
    }
    t.next = p ?? q
    return dummy.next
}
```

### Dart

```dart
ListNode? mergeTwoLists(ListNode? a, ListNode? b) {
  final dummy = ListNode(0);
  var t = dummy;
  var p = a, q = b;
  while (p != null && q != null) {
    if (p.val <= q.val) { t.next = p; p = p.next; }
    else { t.next = q; q = q.next; }
    t = t.next!;
  }
  t.next = p ?? q;
  return dummy.next;
}
```

### TypeScript

```typescript
function mergeTwoLists(a: ListNode | null, b: ListNode | null): ListNode | null {
  const dummy = new ListNode(0);
  let t = dummy, p = a, q = b;
  while (p && q) {
    if (p.val <= q.val) { t.next = p; p = p.next; }
    else { t.next = q; q = q.next; }
    t = t.next!;
  }
  t.next = p ?? q;
  return dummy.next;
}
```

## Q13. Maximum Depth of Binary Tree

**Topic:** Trees

**Statement**

Return max depth of a binary tree. Framing: deepest nested JSON / view subtree.

**Approach**

DFS: `1 + max(left, right)`; or BFS levels.

**Complexity:** Time O(n), Space O(h)

### Kotlin

```kotlin
class TreeNode(var `val`: Int, var left: TreeNode? = null, var right: TreeNode? = null)
fun maxDepth(root: TreeNode?): Int =
    if (root == null) 0 else 1 + maxOf(maxDepth(root.left), maxDepth(root.right))
```

### Swift

```swift
class TreeNode {
    var val: Int; var left: TreeNode?; var right: TreeNode?
    init(_ val: Int) { self.val = val }
}
func maxDepth(_ root: TreeNode?) -> Int {
    guard let r = root else { return 0 }
    return 1 + max(maxDepth(r.left), maxDepth(r.right))
}
```

### Dart

```dart
class TreeNode {
  int val; TreeNode? left, right;
  TreeNode(this.val, [this.left, this.right]);
}
int maxDepth(TreeNode? root) {
  if (root == null) return 0;
  final l = maxDepth(root.left), r = maxDepth(root.right);
  return 1 + (l > r ? l : r);
}
```

### TypeScript

```typescript
class TreeNode {
  val: number; left: TreeNode | null; right: TreeNode | null;
  constructor(val = 0, left: TreeNode | null = null, right: TreeNode | null = null) {
    this.val = val; this.left = left; this.right = right;
  }
}
function maxDepth(root: TreeNode | null): number {
  if (!root) return 0;
  return 1 + Math.max(maxDepth(root.left), maxDepth(root.right));
}
```

## Q14. Invert Binary Tree

**Topic:** Trees

**Statement**

Swap every left/right child. Framing: RTL layout mirror of a settings tree.

**Approach**

DFS/BFS swap children at each node.

**Complexity:** Time O(n), Space O(h)

### Kotlin

```kotlin
fun invertTree(root: TreeNode?): TreeNode? {
    if (root == null) return null
    val tmp = root.left
    root.left = invertTree(root.right)
    root.right = invertTree(tmp)
    return root
}
```

### Swift

```swift
func invertTree(_ root: TreeNode?) -> TreeNode? {
    guard let r = root else { return nil }
    let tmp = r.left
    r.left = invertTree(r.right)
    r.right = invertTree(tmp)
    return r
}
```

### Dart

```dart
TreeNode? invertTree(TreeNode? root) {
  if (root == null) return null;
  final tmp = root.left;
  root.left = invertTree(root.right);
  root.right = invertTree(tmp);
  return root;
}
```

### TypeScript

```typescript
function invertTree(root: TreeNode | null): TreeNode | null {
  if (!root) return null;
  const tmp = root.left;
  root.left = invertTree(root.right);
  root.right = invertTree(tmp);
  return root;
}
```

## Q15. Validate BST

**Topic:** Trees

**Statement**

Check whether a binary tree is a valid BST. Framing: validate an in-memory ordered index.

**Approach**

DFS with `(low, high)` bounds tightened along the path.

**Complexity:** Time O(n), Space O(h)

### Kotlin

```kotlin
fun isValidBST(root: TreeNode?): Boolean {
    fun go(n: TreeNode?, lo: Long, hi: Long): Boolean {
        if (n == null) return true
        val v = n.`val`.toLong()
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
    if (lo != null && n.val <= lo) return false;
    if (hi != null && n.val >= hi) return false;
    return go(n.left, lo, n.val) && go(n.right, n.val, hi);
  }
  return go(root, null, null);
}
```

### TypeScript

```typescript
function isValidBST(root: TreeNode | null): boolean {
  function go(n: TreeNode | null, lo: number | null, hi: number | null): boolean {
    if (!n) return true;
    if (lo !== null && n.val <= lo) return false;
    if (hi !== null && n.val >= hi) return false;
    return go(n.left, lo, n.val) && go(n.right, n.val, hi);
  }
  return go(root, null, null);
}
```

## Q16. Binary Tree Level Order

**Topic:** Trees

**Statement**

Return values level by level. Framing: render org-chart rows / comment threads by depth.

**Approach**

BFS queue; for each level size, drain that many nodes.

**Complexity:** Time O(n), Space O(n)

### Kotlin

```kotlin
fun levelOrder(root: TreeNode?): List<List<Int>> {
    if (root == null) return emptyList()
    val q = ArrayDeque<TreeNode>()
    q.add(root)
    val out = mutableListOf<List<Int>>()
    while (q.isNotEmpty()) {
        val level = mutableListOf<Int>()
        repeat(q.size) {
            val n = q.removeFirst()
            level.add(n.`val`)
            n.left?.let(q::add)
            n.right?.let(q::add)
        }
        out.add(level)
    }
    return out
}
```

### Swift

```swift
func levelOrder(_ root: TreeNode?) -> [[Int]] {
    guard let root else { return [] }
    var q: [TreeNode] = [root], out: [[Int]] = []
    var head = 0
    while head < q.count {
        var level: [Int] = []
        let count = q.count - head
        for _ in 0..<count {
            let n = q[head]; head += 1
            level.append(n.val)
            if let l = n.left { q.append(l) }
            if let r = n.right { q.append(r) }
        }
        out.append(level)
    }
    return out
}
```

### Dart

```dart
List<List<int>> levelOrder(TreeNode? root) {
  if (root == null) return [];
  final q = <TreeNode>[root];
  final out = <List<int>>[];
  var head = 0;
  while (head < q.length) {
    final level = <int>[];
    final count = q.length - head;
    for (var i = 0; i < count; i++) {
      final n = q[head++];
      level.add(n.val);
      if (n.left != null) q.add(n.left!);
      if (n.right != null) q.add(n.right!);
    }
    out.add(level);
  }
  return out;
}
```

### TypeScript

```typescript
function levelOrder(root: TreeNode | null): number[][] {
  if (!root) return [];
  const q: TreeNode[] = [root];
  const out: number[][] = [];
  let head = 0;
  while (head < q.length) {
    const size = q.length - head;
    const level: number[] = [];
    for (let i = 0; i < size; i++) {
      const n = q[head++];
      level.push(n.val);
      if (n.left) q.push(n.left);
      if (n.right) q.push(n.right);
    }
    out.push(level);
  }
  return out;
}
```

## Q17. Lowest Common Ancestor of BST

**Topic:** Trees

**Statement**

Find LCA of two nodes in a BST. Framing: common ancestor screen in a settings hierarchy keyed by ordered ids.

**Approach**

Walk from root: if both < node go left; both > go right; else node is LCA.

**Complexity:** Time O(h), Space O(1) iterative

### Kotlin

```kotlin
fun lowestCommonAncestor(root: TreeNode?, p: TreeNode?, q: TreeNode?): TreeNode? {
    var cur = root
    val a = p!!.`val`; val b = q!!.`val`
    while (cur != null) {
        cur = when {
            a < cur.`val` && b < cur.`val` -> cur.left
            a > cur.`val` && b > cur.`val` -> cur.right
            else -> return cur
        }
    }
    return null
}
```

### Swift

```swift
func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
    var cur = root
    let a = p!.val, b = q!.val
    while let c = cur {
        if a < c.val && b < c.val { cur = c.left }
        else if a > c.val && b > c.val { cur = c.right }
        else { return c }
    }
    return nil
}
```

### Dart

```dart
TreeNode? lowestCommonAncestor(TreeNode? root, TreeNode? p, TreeNode? q) {
  var cur = root;
  final a = p!.val, b = q!.val;
  while (cur != null) {
    if (a < cur.val && b < cur.val) cur = cur.left;
    else if (a > cur.val && b > cur.val) cur = cur.right;
    else return cur;
  }
  return null;
}
```

### TypeScript

```typescript
function lowestCommonAncestor(root: TreeNode | null, p: TreeNode | null, q: TreeNode | null): TreeNode | null {
  let cur = root;
  const a = p!.val, b = q!.val;
  while (cur) {
    if (a < cur.val && b < cur.val) cur = cur.left;
    else if (a > cur.val && b > cur.val) cur = cur.right;
    else return cur;
  }
  return null;
}
```

## Q18. Binary Search

**Topic:** Binary search

**Statement**

Find index of `target` in sorted `nums`, or -1. Framing: jump to a transcript timestamp in a sorted cue list.

**Approach**

Classic mid compare; watch overflow-safe mid.

**Complexity:** Time O(log n), Space O(1)

### Kotlin

```kotlin
fun search(nums: IntArray, target: Int): Int {
    var lo = 0; var hi = nums.lastIndex
    while (lo <= hi) {
        val mid = (lo + hi) ushr 1
        when {
            nums[mid] == target -> return mid
            nums[mid] < target -> lo = mid + 1
            else -> hi = mid - 1
        }
    }
    return -1
}
```

### Swift

```swift
func search(_ nums: [Int], _ target: Int) -> Int {
    var lo = 0, hi = nums.count - 1
    while lo <= hi {
        let mid = (lo + hi) / 2
        if nums[mid] == target { return mid }
        if nums[mid] < target { lo = mid + 1 } else { hi = mid - 1 }
    }
    return -1
}
```

### Dart

```dart
int search(List<int> nums, int target) {
  var lo = 0, hi = nums.length - 1;
  while (lo <= hi) {
    final mid = (lo + hi) >> 1;
    if (nums[mid] == target) return mid;
    if (nums[mid] < target) lo = mid + 1; else hi = mid - 1;
  }
  return -1;
}
```

### TypeScript

```typescript
function search(nums: number[], target: number): number {
  let lo = 0, hi = nums.length - 1;
  while (lo <= hi) {
    const mid = (lo + hi) >> 1;
    if (nums[mid] === target) return mid;
    if (nums[mid] < target) lo = mid + 1; else hi = mid - 1;
  }
  return -1;
}
```

## Q19. Search Insert Position (Lower Bound)

**Topic:** Binary search

**Statement**

Return index where `target` is or should be inserted in sorted array. Framing: insert a message into a timestamp-sorted buffer.

**Approach**

Lower bound binary search — first index with `nums[i] >= target`.

**Complexity:** Time O(log n), Space O(1)

### Kotlin

```kotlin
fun searchInsert(nums: IntArray, target: Int): Int {
    var lo = 0; var hi = nums.size
    while (lo < hi) {
        val mid = (lo + hi) ushr 1
        if (nums[mid] < target) lo = mid + 1 else hi = mid
    }
    return lo
}
```

### Swift

```swift
func searchInsert(_ nums: [Int], _ target: Int) -> Int {
    var lo = 0, hi = nums.count
    while lo < hi {
        let mid = (lo + hi) / 2
        if nums[mid] < target { lo = mid + 1 } else { hi = mid }
    }
    return lo
}
```

### Dart

```dart
int searchInsert(List<int> nums, int target) {
  var lo = 0, hi = nums.length;
  while (lo < hi) {
    final mid = (lo + hi) >> 1;
    if (nums[mid] < target) lo = mid + 1; else hi = mid;
  }
  return lo;
}
```

### TypeScript

```typescript
function searchInsert(nums: number[], target: number): number {
  let lo = 0, hi = nums.length;
  while (lo < hi) {
    const mid = (lo + hi) >> 1;
    if (nums[mid] < target) lo = mid + 1; else hi = mid;
  }
  return lo;
}
```

## Q20. Find Peak Element

**Topic:** Binary search

**Statement**

A peak is greater than neighbors; return any peak index. Framing: find a local maximum in a sampled battery/CPU series (unsorted).

**Approach**

Binary search on slope: if `mid < mid+1` climb right, else left. Ends are peaks if descending inward.

**Complexity:** Time O(log n), Space O(1)

### Kotlin

```kotlin
fun findPeakElement(nums: IntArray): Int {
    var lo = 0; var hi = nums.lastIndex
    while (lo < hi) {
        val mid = (lo + hi) ushr 1
        if (nums[mid] < nums[mid + 1]) lo = mid + 1 else hi = mid
    }
    return lo
}
```

### Swift

```swift
func findPeakElement(_ nums: [Int]) -> Int {
    var lo = 0, hi = nums.count - 1
    while lo < hi {
        let mid = (lo + hi) / 2
        if nums[mid] < nums[mid + 1] { lo = mid + 1 } else { hi = mid }
    }
    return lo
}
```

### Dart

```dart
int findPeakElement(List<int> nums) {
  var lo = 0, hi = nums.length - 1;
  while (lo < hi) {
    final mid = (lo + hi) >> 1;
    if (nums[mid] < nums[mid + 1]) lo = mid + 1; else hi = mid;
  }
  return lo;
}
```

### TypeScript

```typescript
function findPeakElement(nums: number[]): number {
  let lo = 0, hi = nums.length - 1;
  while (lo < hi) {
    const mid = (lo + hi) >> 1;
    if (nums[mid] < nums[mid + 1]) lo = mid + 1; else hi = mid;
  }
  return lo;
}
```

## Q21. Number of Provinces (Connected Components)

**Topic:** Graphs BFS/DFS

**Statement**

`isConnected[i][j] == 1` means cities linked. Count provinces. Framing: count sync clusters of devices.

**Approach**

DFS/BFS/Union-Find over unvisited nodes; each start increments count.

**Complexity:** Time O(n²) for matrix, Space O(n)

### Kotlin

```kotlin
fun findCircleNum(isConnected: Array<IntArray>): Int {
    val n = isConnected.size
    val seen = BooleanArray(n)
    fun dfs(i: Int) {
        seen[i] = true
        for (j in 0 until n) if (isConnected[i][j] == 1 && !seen[j]) dfs(j)
    }
    var provinces = 0
    for (i in 0 until n) if (!seen[i]) { provinces++; dfs(i) }
    return provinces
}
```

### Swift

```swift
func findCircleNum(_ isConnected: [[Int]]) -> Int {
    let n = isConnected.count
    var seen = Array(repeating: false, count: n)
    func dfs(_ i: Int) {
        seen[i] = true
        for j in 0..<n where isConnected[i][j] == 1 && !seen[j] { dfs(j) }
    }
    var provinces = 0
    for i in 0..<n where !seen[i] { provinces += 1; dfs(i) }
    return provinces
}
```

## Q22. Clone Graph

**Topic:** Graphs BFS/DFS

**Statement**

Deep-clone a connected undirected graph of nodes with neighbor lists. Framing: snapshot a social “nearby” graph for offline.

**Approach**

Hash map `old → new`. DFS/BFS: create clone, then wire neighbors via map.

**Complexity:** Time O(V+E), Space O(V)

### Dart

```dart
class GraphNode {
  int val; List<GraphNode> neighbors;
  GraphNode(this.val, [List<GraphNode>? neighbors]) : neighbors = neighbors ?? [];
}
GraphNode? cloneGraph(GraphNode? node) {
  if (node == null) return null;
  final map = <GraphNode, GraphNode>{};
  GraphNode dfs(GraphNode n) {
    if (map.containsKey(n)) return map[n]!;
    final c = GraphNode(n.val);
    map[n] = c;
    for (final nb in n.neighbors) c.neighbors.add(dfs(nb));
    return c;
  }
  return dfs(node);
}
```

### TypeScript

```typescript
class GraphNode {
  val: number; neighbors: GraphNode[];
  constructor(val = 0, neighbors: GraphNode[] = []) { this.val = val; this.neighbors = neighbors; }
}
function cloneGraph(node: GraphNode | null): GraphNode | null {
  if (!node) return null;
  const map = new Map<GraphNode, GraphNode>();
  function dfs(n: GraphNode): GraphNode {
    if (map.has(n)) return map.get(n)!;
    const c = new GraphNode(n.val);
    map.set(n, c);
    for (const nb of n.neighbors) c.neighbors.push(dfs(nb));
    return c;
  }
  return dfs(node);
}
```

## Q23. Course Schedule (Cycle Detect)

**Topic:** Graphs BFS/DFS

**Statement**

`prerequisites[i] = [a,b]` means b before a. Can you finish all courses? Framing: can onboarding checklist modules be ordered?

**Approach**

Build adj + indegree; Kahn’s BFS topological sort; if processed < n ⇒ cycle.

**Complexity:** Time O(V+E), Space O(V+E)

### Kotlin

```kotlin
fun canFinish(numCourses: Int, prerequisites: Array<IntArray>): Boolean {
    val adj = List(numCourses) { mutableListOf<Int>() }
    val indeg = IntArray(numCourses)
    for (e in prerequisites) { adj[e[1]].add(e[0]); indeg[e[0]]++ }
    val q = ArrayDeque<Int>()
    for (i in indeg.indices) if (indeg[i] == 0) q.add(i)
    var seen = 0
    while (q.isNotEmpty()) {
        val u = q.removeFirst(); seen++
        for (v in adj[u]) if (--indeg[v] == 0) q.add(v)
    }
    return seen == numCourses
}
```

### Swift

```swift
func canFinish(_ numCourses: Int, _ prerequisites: [[Int]]) -> Bool {
    var adj = Array(repeating: [Int](), count: numCourses)
    var indeg = Array(repeating: 0, count: numCourses)
    for e in prerequisites { adj[e[1]].append(e[0]); indeg[e[0]] += 1 }
    var q: [Int] = []
    for i in 0..<numCourses where indeg[i] == 0 { q.append(i) }
    var seen = 0, head = 0
    while head < q.count {
        let u = q[head]; head += 1; seen += 1
        for v in adj[u] { indeg[v] -= 1; if indeg[v] == 0 { q.append(v) } }
    }
    return seen == numCourses
}
```

## Q24. Shortest Path in Unweighted Graph

**Topic:** Graphs BFS/DFS

**Statement**

Given adjacency list and `start`/`end`, return shortest hop distance or -1. Framing: fewest taps between settings screens.

**Approach**

BFS; first time reaching `end` is minimal hops. Mark seen on enqueue.

**Complexity:** Time O(V+E), Space O(V)

### Dart

```dart
int shortestPath(Map<int, List<int>> g, int start, int end) {
  if (start == end) return 0;
  final seen = <int>{start};
  final q = <int>[start];
  var head = 0, dist = 0;
  while (head < q.length) {
    final size = q.length - head;
    for (var i = 0; i < size; i++) {
      final u = q[head++];
      for (final v in g[u] ?? const <int>[]) {
        if (v == end) return dist + 1;
        if (seen.add(v)) q.add(v);
      }
    }
    dist++;
  }
  return -1;
}
```

### TypeScript

```typescript
function shortestPath(g: Map<number, number[]>, start: number, end: number): number {
  if (start === end) return 0;
  const seen = new Set<number>([start]);
  const q = [start];
  let head = 0, dist = 0;
  while (head < q.length) {
    const size = q.length - head;
    for (let i = 0; i < size; i++) {
      const u = q[head++];
      for (const v of g.get(u) ?? []) {
        if (v === end) return dist + 1;
        if (!seen.has(v)) { seen.add(v); q.push(v); }
      }
    }
    dist++;
  }
  return -1;
}
```

## Q25. Kth Largest Element

**Topic:** Heaps

**Statement**

Find the kth largest in an unsorted array. Framing: kth longest session in analytics.

**Approach**

Size-k min-heap of largest values; root is answer. Or QuickSelect average O(n).

**Complexity:** Time O(n log k), Space O(k)

### Kotlin

```kotlin
fun findKthLargest(nums: IntArray, k: Int): Int {
    val pq = java.util.PriorityQueue<Int>()
    for (x in nums) {
        pq.add(x)
        if (pq.size > k) pq.poll()
    }
    return pq.peek()
}
```

### Swift

```swift
// Min-heap via array for interview clarity
func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
    var heap = [Int]()
    func siftUp(_ i: Int) {
        var i = i
        while i > 0 {
            let p = (i - 1) / 2
            if heap[p] <= heap[i] { break }
            heap.swapAt(p, i); i = p
        }
    }
    func siftDown(_ i: Int) {
        var i = i
        while true {
            var s = i
            let l = 2 * i + 1, r = l + 1
            if l < heap.count && heap[l] < heap[s] { s = l }
            if r < heap.count && heap[r] < heap[s] { s = r }
            if s == i { break }
            heap.swapAt(i, s); i = s
        }
    }
    for x in nums {
        if heap.count < k { heap.append(x); siftUp(heap.count - 1) }
        else if x > heap[0] { heap[0] = x; siftDown(0) }
    }
    return heap[0]
}
```

## Q26. Merge K Sorted Lists (Feed Merge)

**Topic:** Heaps

**Statement**

Merge k sorted linked lists. Framing: merge k sorted notification streams.

**Approach**

Min-heap of current heads keyed by value; pop, append, push next. The Dart/TS sketches below use **pairwise divide-and-conquer merge** (also correct; O(N log k) with different constants) when a stdlib heap is awkward.

**Complexity:** Time O(N log k), Space O(k) (heap) or O(1) extra beyond output for pairwise merge

### Dart

```dart
ListNode? mergeKLists(List<ListNode?> lists) {
  // simple pairwise merge for sketch without package heap:
  ListNode? merge(ListNode? a, ListNode? b) {
    final d = ListNode(0); var t = d;
    var p = a, q = b;
    while (p != null && q != null) {
      if (p.val <= q.val) { t.next = p; p = p.next; }
      else { t.next = q; q = q.next; }
      t = t.next!;
    }
    t.next = p ?? q;
    return d.next;
  }
  if (lists.isEmpty) return null;
  var interval = 1;
  while (interval < lists.length) {
    for (var i = 0; i + interval < lists.length; i += interval * 2) {
      lists[i] = merge(lists[i], lists[i + interval]);
    }
    interval *= 2;
  }
  return lists[0];
}
```

### TypeScript

```typescript
function mergeKLists(lists: (ListNode | null)[]): ListNode | null {
  function merge(a: ListNode | null, b: ListNode | null): ListNode | null {
    const d = new ListNode(0); let t = d, p = a, q = b;
    while (p && q) {
      if (p.val <= q.val) { t.next = p; p = p.next; } else { t.next = q; q = q.next; }
      t = t.next!;
    }
    t.next = p ?? q; return d.next;
  }
  if (!lists.length) return null;
  let interval = 1;
  while (interval < lists.length) {
    for (let i = 0; i + interval < lists.length; i += interval * 2) {
      lists[i] = merge(lists[i], lists[i + interval]);
    }
    interval *= 2;
  }
  return lists[0];
}
```

## Q27. Meeting Rooms / Min Platforms (Heap)

**Topic:** Heaps

**Statement**

Given intervals `[start,end)`, return minimum number of concurrent rooms needed. Framing: min parallel download slots.

**Approach**

Sort by start; min-heap of end times; if next start >= earliest end, reuse; else new room.

**Complexity:** Time O(n log n), Space O(n)

### Kotlin

```kotlin
fun minMeetingRooms(intervals: Array<IntArray>): Int {
    if (intervals.isEmpty()) return 0
    intervals.sortBy { it[0] }
    val ends = java.util.PriorityQueue<Int>()
    ends.add(intervals[0][1])
    for (i in 1 until intervals.size) {
        if (intervals[i][0] >= ends.peek()) ends.poll()
        ends.add(intervals[i][1])
    }
    return ends.size
}
```

### Swift

```swift
func minMeetingRooms(_ intervals: [[Int]]) -> Int {
    let sorted = intervals.sorted { $0[0] < $1[0] }
    // Toy min-heap via sorted array — O(n) per push/pop → O(n² log n) worst.
    // Prefer a real binary heap (Chapter 18) for production / large n.
    var ends: [Int] = []
    func push(_ x: Int) { ends.append(x); ends.sort() }
    func popMin() { ends.removeFirst() }
    for (i, iv) in sorted.enumerated() {
        if i == 0 { push(iv[1]); continue }
        if let e = ends.first, iv[0] >= e { popMin() }
        push(iv[1])
    }
    return ends.count
}
```

## Q28. Climbing Stairs

**Topic:** DP lite

**Statement**

Ways to climb `n` stairs taking 1 or 2 at a time. Framing: count onboarding paths with optional skip.

**Approach**

`dp[i] = dp[i-1] + dp[i-2]`; roll two variables.

**Complexity:** Time O(n), Space O(1)

### Dart

```dart
int climbStairs(int n) {
  if (n <= 2) return n;
  var a = 1, b = 2;
  for (var i = 3; i <= n; i++) {
    final c = a + b; a = b; b = c;
  }
  return b;
}
```

### TypeScript

```typescript
function climbStairs(n: number): number {
  if (n <= 2) return n;
  let a = 1, b = 2;
  for (let i = 3; i <= n; i++) { const c = a + b; a = b; b = c; }
  return b;
}
```

## Q29. House Robber

**Topic:** DP lite

**Statement**

Max sum of non-adjacent houses. Framing: max score picking non-adjacent feed cards for a highlight reel.

**Approach**

`dp[i] = max(dp[i-1], dp[i-2] + nums[i])`.

**Complexity:** Time O(n), Space O(1)

### Kotlin

```kotlin
fun rob(nums: IntArray): Int {
    var prev2 = 0; var prev1 = 0
    for (x in nums) {
        val cur = maxOf(prev1, prev2 + x)
        prev2 = prev1; prev1 = cur
    }
    return prev1
}
```

### Swift

```swift
func rob(_ nums: [Int]) -> Int {
    var prev2 = 0, prev1 = 0
    for x in nums {
        let cur = max(prev1, prev2 + x)
        prev2 = prev1; prev1 = cur
    }
    return prev1
}
```

## Q30. Coin Change

**Topic:** DP lite

**Statement**

Fewest coins to make `amount` from unlimited `coins`, or -1. Framing: fewest denomination taps in a wallet UI (when greedy fails).

**Approach**

`dp[x] = min over coin c of dp[x-c] + 1`; init `dp[0]=0`, else ∞.

**Complexity:** Time O(amount · |coins|), Space O(amount)

### Dart

```dart
int coinChange(List<int> coins, int amount) {
  final dp = List.filled(amount + 1, amount + 1);
  dp[0] = 0;
  for (var x = 1; x <= amount; x++) {
    for (final c in coins) {
      if (c <= x) dp[x] = dp[x] < dp[x - c] + 1 ? dp[x] : dp[x - c] + 1;
    }
  }
  return dp[amount] > amount ? -1 : dp[amount];
}
```

### TypeScript

```typescript
function coinChange(coins: number[], amount: number): number {
  const dp = Array(amount + 1).fill(amount + 1);
  dp[0] = 0;
  for (let x = 1; x <= amount; x++) {
    for (const c of coins) if (c <= x) dp[x] = Math.min(dp[x], dp[x - c] + 1);
  }
  return dp[amount] > amount ? -1 : dp[amount];
}
```

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

## Q32. First Unique Character

**Topic:** Strings

**Statement**

Index of first non-repeating character, or -1. Framing: first unique glyph for avatar color hash fallback.

**Approach**

Count frequencies; second pass find first with count 1.

**Complexity:** Time O(n), Space O(Σ)

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

## Q34. Reverse Words in a String

**Topic:** Strings

**Statement**

Reverse word order; trim / collapse spaces. Framing: flip RTL preview of a multi-word title.

**Approach**

Split on whitespace; reverse tokens; join with single spaces. Or two-pointer reverse whole then each word.

**Complexity:** Time O(n), Space O(n)

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

## Q37. Thread-Safe Request Coalescer (Single-Flight)

**Topic:** Concurrency / design

**Statement**

Concurrent `load(key)` shares one in-flight fetch. Framing: image/config downloads.

**Approach**

Map key → shared Deferred/Promise; create on miss; remove in `finally`.

**Complexity:** O(1) map ops + producer cost once

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
        let elapsed = last.duration(to: now).seconds
        last = now
        tokens = min(capacity, tokens + elapsed * rate)
        guard tokens >= 1 else { return false }
        tokens -= 1; return true
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

---

## Closing drill advice

- Re-solve any question you needed hints for after **48 hours**.
- Speak the **mobile note** in mocks — it differentiates app engineers from generic grinders.
- Use Appendix A’s Week 12 to time **20+** of these under interview conditions.

Next: [Chapter 25 — Mini Projects](25-mini-projects.md) · Index: [`solutions/ch24`](../../solutions/ch24/README.md).
