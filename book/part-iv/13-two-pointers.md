# Chapter 13 — Two Pointers

Many array and list problems look like they need a nested loop: "for every item, look at every other item". Two pointers turns a lot of those O(n²) scans into one O(n) pass. You walk two indices through the data together, and each step lets you rule out a whole group of candidates for good.

This is the first of five **Core Patterns** chapters. Chapters 3–12 taught you the structures. This Part teaches the moves that interviewers expect you to reach for without being prompted.

---

## Mobile motivation

- A synced message list arrives **sorted by timestamp** with duplicates from a retry. You need to dedupe it in place before diffing, without allocating a second 10k-element array during scroll.
- A contact search treats `"jdoe"` as a match for `"John Doe"` if the typed letters appear **in order**. That check runs per row per keystroke, so it must be linear and allocation-free.
- An inbox needs **unread first, then read, then archived**. That is one pass with three pointers, not a full sort.
- A linked playback queue needs its **middle item** for a "jump to halfway" button, without counting the list first.

Each one is a single pass with two (or three) indices moving under a clear rule.

---

## The three shapes

| Shape | Pointers start | Move rule | Typical use |
|-------|----------------|-----------|-------------|
| **Opposite ends** | `lo = 0`, `hi = n - 1` | Move the side that cannot be part of a better answer | Sorted pair sums, palindromes, container/area problems, squares of a sorted array |
| **Read / write (same direction)** | `write = 0`, `read` scans | `read` looks at every item; `write` marks where the next kept item goes | In-place dedupe, filter, move zeroes, compaction |
| **Fast / slow** | Both at head | `fast` moves 2 steps, `slow` moves 1 | Middle of a list, cycle detection (Floyd), "k-th from end" with a gap |

A fourth variant runs **one pointer per sequence** (two cursors over two arrays or strings). Merging sorted arrays (Chapter 21) and the subsequence check below both use it.

### Why it is correct: the invariant

Two-pointer code is only correct if you can state what is true at every step:

- **Opposite ends (sorted pair sum):** "No pair using an index outside `[lo, hi]` can be the answer." If `a[lo] + a[hi] < target`, then `a[lo]` paired with anything at or below `hi` is too small too, so `lo++` safely throws away every pair that uses `lo`.
- **Read/write:** "`a[0 until write]` is exactly the kept output so far, in order."
- **Fast/slow:** "`fast` has gone twice as far as `slow`." When `fast` reaches the end, `slow` is in the middle.

If you cannot say the invariant, you are guessing. Interviewers ask for it.

---

## Complexity at a glance

| Problem shape | Brute force | Two pointers | Extra space |
|---------------|-------------|--------------|-------------|
| Pair with target sum (sorted) | O(n²) | O(n) | O(1) |
| Dedupe sorted array | O(n) with a new set/array | O(n) in place | O(1) |
| Is `s` a subsequence of `t` | Exponential or O(n·m) if done naively | O(n + m) | O(1) |
| Middle of a linked list | O(n) count + O(n/2) walk | O(n) single pass | O(1) |
| Partition into 3 groups | O(n log n) sort | O(n) | O(1) |

The big win is usually **space**: same time class as a hash-based approach, with no auxiliary allocation. On a phone that means no GC/ARC churn while the list is scrolling.

---

## How to recognize it

Reach for two pointers when you see:

1. **Sorted input** together with "pair", "triplet", "closest" or "at most".
2. **In place** or **O(1) extra space** in the constraints.
3. "Remove", "move to the end" or "compact" while **keeping relative order**.
4. A **linked list** where you need a position (middle, k-th from the end) or need to find a cycle.
5. Two sequences that must be walked **in step** (merge, subsequence, intersection of sorted lists).

If the input is **unsorted** and you need pairs, the default is a hash map (Chapter 7), unless sorting first (O(n log n)) is acceptable and the answer doesn't need the original indices.

---

## Platform bridges

| Platform | Where it shows up |
|----------|-------------------|
| **Android** | Compacting a `MutableList` in place before `submitList`. `removeAll { }` on an `ArrayList` is itself a read/write compaction internally. `ListAdapter`'s diff walks old and new lists with cursors. |
| **iOS** | `removeAll(where:)` on `Array` is an in-place O(n) compaction (one write cursor). Use it instead of looping `remove(at:)`, which is O(n²). |
| **Flutter** | `List.removeWhere` compacts in place. Fuzzy matchers in search pickers often do a subsequence check per item. |
| **React Native** | `Array.prototype.filter` allocates a new array. For hot paths over large arrays, an in-place write cursor plus `length = write` avoids the copy. |

Rule of thumb: **never call `remove(at:)` / `removeAt` / `splice` inside a loop over the same array.** Each call shifts the tail, which makes the loop O(n²). A write cursor does the same job in O(n).

---

## Worked example 1: dedupe a sorted array in place (read/write)

Input: timestamps sorted ascending, possibly with repeats from a retried sync. Keep one copy of each value, in order, in the front of the array, and return how many are kept.

Invariant: `a[0 until write]` holds the unique values seen so far. The last kept value is `a[write - 1]`.

### Kotlin

```kotlin
fun dedupeSortedInPlace(a: IntArray): Int {
    if (a.isEmpty()) return 0
    var write = 1                          // a[0] is always kept
    for (read in 1 until a.size) {
        if (a[read] != a[write - 1]) {     // new value
            a[write] = a[read]
            write++
        }
    }
    return write                           // a[0 until write] is the result
}
```

### Swift

```swift
func dedupeSortedInPlace(_ a: inout [Int]) -> Int {
    if a.isEmpty { return 0 }
    var write = 1
    for read in 1..<a.count where a[read] != a[write - 1] {
        a[write] = a[read]
        write += 1
    }
    return write
}
```

### Dart

```dart
int dedupeSortedInPlace(List<int> a) {
  if (a.isEmpty) return 0;
  var write = 1;
  for (var read = 1; read < a.length; read++) {
    if (a[read] != a[write - 1]) {
      a[write] = a[read];
      write++;
    }
  }
  return write;
}
```

### TypeScript

```typescript
function dedupeSortedInPlace(a: number[]): number {
  if (a.length === 0) return 0;
  let write = 1;
  for (let read = 1; read < a.length; read++) {
    if (a[read] !== a[write - 1]) {
      a[write] = a[read];
      write++;
    }
  }
  return write; // caller may do a.length = write
}
```

**Complexity:** O(n) time, O(1) extra space. **Mobile note:** this is safe to run on the main thread for a few thousand items. The point is that it allocates nothing, so a scroll-time GC pause can't happen.

---

## Worked example 2: is the query a subsequence of the name? (one cursor per sequence)

`"jdoe"` matches `"john doe"` because `j`, `d`, `o`, `e` appear in that order. Walk the name once. Advance the query cursor only when the characters match.

Invariant: `query[0 until qi]` has been matched, in order, inside `name[0 until ni]`.

### Kotlin

```kotlin
fun isSubsequence(query: String, name: String): Boolean {
    var qi = 0
    for (ch in name) {
        if (qi == query.length) break
        if (ch.lowercaseChar() == query[qi].lowercaseChar()) qi++
    }
    return qi == query.length
}
```

### Swift

```swift
func isSubsequence(_ query: String, _ name: String) -> Bool {
    let q = Array(query.lowercased())
    var qi = 0
    for ch in name.lowercased() {
        if qi == q.count { break }
        if ch == q[qi] { qi += 1 }
    }
    return qi == q.count
}
```

### Dart

```dart
bool isSubsequence(String query, String name) {
  final q = query.toLowerCase();
  final n = name.toLowerCase();
  var qi = 0;
  for (var ni = 0; ni < n.length && qi < q.length; ni++) {
    if (n.codeUnitAt(ni) == q.codeUnitAt(qi)) qi++;
  }
  return qi == q.length;
}
```

### TypeScript

```typescript
function isSubsequence(query: string, name: string): boolean {
  const q = query.toLowerCase();
  const n = name.toLowerCase();
  let qi = 0;
  for (let ni = 0; ni < n.length && qi < q.length; ni++) {
    if (n[ni] === q[qi]) qi++;
  }
  return qi === q.length;
}
```

**Complexity:** O(|name|) time, O(1) extra space (the Swift version builds an array from the short query, which costs O(|query|)). **Mobile note:** Dart and TypeScript compare UTF-16 code units. That's fine for Latin names, but it splits emoji and some scripts. Chapter 26 covers grapheme-safe comparison.

---

## Worked example 3: middle of a linked list (fast/slow)

```kotlin
class Node(val value: Int, var next: Node? = null)

fun middleNode(head: Node?): Node? {
    var slow = head
    var fast = head
    while (fast?.next != null) {
        slow = slow?.next
        fast = fast.next?.next
    }
    return slow // for even length, the second of the two middles
}
```

The same skeleton detects a cycle: if `fast` ever lands on the same node as `slow`, there is a loop (Chapter 4, Floyd's algorithm). Starting `fast` k steps ahead finds the k-th node from the end in one pass ([Ch 34 Q2](../part-viii/34-linked-lists-trees.md)).

---

## Opposite ends in one picture

```text
sorted: [1, 3, 4, 6, 8, 11]   target = 10
         lo             hi    1 + 11 = 12 > 10  → hi--  (11 is too big with anything ≥ 1)
         lo          hi       1 + 8  = 9  < 10  → lo++  (1 is too small with anything ≤ 8)
            lo       hi       3 + 8  = 11 > 10  → hi--
            lo    hi          3 + 6  = 9  < 10  → lo++
               lo hi          4 + 6  = 10       ✓
```

Every move throws away a whole row or column of the n×n pair grid. That is why the scan is O(n). The full drill with code is [Ch 32 Q2 — Two Sum II](../part-viii/32-two-pointers-windows-intervals.md).

---

## Common mistakes

1. **Using opposite ends on unsorted data.** The "move the smaller side" argument only holds if the input is sorted. Without sorting it is just wrong.
2. **Off-by-one in read/write.** Comparing against `a[write]` instead of `a[write - 1]` (the last *kept* value) keeps duplicates.
3. **`while (lo <= hi)` when a pair needs two different indices.** For pairs, use `lo < hi`, or you'll pair an element with itself.
4. **Calling `remove(at:)` inside the loop.** It hides an O(n) shift in each step, so the loop becomes O(n²). Compact with a write cursor and truncate once.
5. **Null-unsafe fast/slow.** Check `fast != null && fast.next != null` before stepping two nodes.
6. **Skipping duplicates incorrectly in 3Sum-style problems.** Skip after you use a value, not before you have checked it.

---

## Self-Check

**13.1** State the invariant that makes "move `lo` when the sum is too small" correct in a sorted pair-sum search.

**13.2** Why is `list.removeAt(i)` inside a loop over the same list O(n²), and what replaces it?

**13.3** In fast/slow pointers, why does `slow` end at the middle?

**13.4** The input is unsorted and you must return the original indices of a pair that sums to a target. Two pointers or hash map? Why?

**13.5** Give one mobile reason to prefer the O(1)-space two-pointer version over an O(n)-space set version with the same time complexity.

*(Answers: Appendix D.)*

---

## Practice

1. **Move zeroes (keep order)** — move every `0` to the end in place, keeping the order of the other items (dismissed cards sink to the bottom). [solutions/ch13](../../solutions/ch13/README.md#p1-move-zeroes)
2. **Squares of a sorted array** — the input is sorted and may contain negatives; return the squares sorted, in O(n). [solutions/ch13](../../solutions/ch13/README.md#p2-squares-of-a-sorted-array)
3. **Sort colors (three-way partition)** — sort values `0, 1, 2` (unread, read, archived) in one pass, in place. [solutions/ch13](../../solutions/ch13/README.md#p3-sort-colors-three-way-partition)

### More practice

- [Ch 32 — Two Pointers, Windows & Intervals](../part-viii/32-two-pointers-windows-intervals.md): Q1 Valid Palindrome · Q2 Two Sum II · Q3 3Sum · Q4 Container With Most Water
- [Ch 29 — Interview Questions, Q11–Q20](../part-viii/29-interview-questions-q11-q20.md): Q11 Linked List Cycle · Q12 Merge Two Sorted Lists
- [Ch 34 — Linked Lists & Trees](../part-viii/34-linked-lists-trees.md): Q1 Reorder List · Q2 Remove Nth Node From End
- [Ch 30 — Hard Drill Bank, Q1–Q10](../part-viii/30-hard-drill-bank-q01-q10.md): Q2 Trapping Rain Water (opposite ends with running maxima)

---

## What to remember

Two pointers is about ruling things out. Each move must throw away candidates you can prove are useless, and saying the invariant is that proof. Sorted input points to opposite ends. "In place, keep order" points to read/write. A linked list where you need a position points to fast/slow. The usual payoff over a hash-based approach is O(1) extra space, which on a phone means no allocation while the user scrolls.

---

Previous: [Chapter 12 — Heaps and Priority Queues](../part-iii/12-heaps-priority-queues.md) · Next: [Chapter 14 — Sliding Window](14-sliding-window.md) · Solutions: [`solutions/ch13`](../../solutions/ch13/README.md)
