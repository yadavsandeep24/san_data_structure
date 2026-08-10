# Chapter 15 — Searching and Sorting You Actually Use

## Mobile motivation

A settings search box, an offline contact list, a sorted timeline merge after sync — these are everyday mobile problems. The wrong lookup choice shows up as: typing lag on every keystroke, battery burn from re-scanning huge arrays, or subtle bugs when “binary search” returns the wrong insertion index for a date range.

Sorting shows up too, but not the way interview prep suggests. On device you almost never invent QuickSort. You call the standard library, pass a comparator, and move on — unless the comparator is unstable, allocates in a hot path, or reorders equal keys and breaks scroll position.

This chapter is about **choosing** linear scan vs binary search vs hash lookup, writing binary search correctly (including bounds), and treating sort as a stdlib skill with sharp edges.

## Choosing a lookup strategy

| Situation | Prefer | Why |
|-----------|--------|-----|
| Unsorted list, n small (tens–low hundreds), one-off | Linear scan | Simple, no prep cost; cache-friendly |
| Same unsorted list, many lookups by key | Hash map / set | Average O(1); build once |
| Sorted array / list, find exact or insert position | Binary search | O(log n); no hash needed |
| Need first/last occurrence among duplicates | Binary search + bounds | Lower/upper bound variants |
| Keys change constantly and order matters | Sorted structure or re-sort + binary | Trade write cost vs read cost |

**Rule of thumb for mobile:** if you look up by ID often, store a `Map` beside the ordered list used for UI. Do not binary-search an unsorted feed, and do not linearly scan a 50k-row SQLite dump in memory on the main thread when an index or map exists.

### Complexity snapshot

| Method | Prep | Query | Extra space |
|--------|------|-------|-------------|
| Linear | O(1) | O(n) | O(1) |
| Sort then binary | O(n log n) | O(log n) | O(1)–O(n) |
| Hash map | O(n) | O(1) avg | O(n) |

## Binary search — the version that does not lie

The classic loop has three failure modes: off-by-one mid, infinite loop when `lo`/`hi` stop moving, and returning “not found” when the caller needed an **insertion index**.

Canonical “find exact, else −1”:

```text
lo = 0, hi = n - 1
while lo <= hi:
  mid = lo + (hi - lo) / 2   // avoid overflow habit
  if a[mid] == target: return mid
  if a[mid] < target: lo = mid + 1
  else: hi = mid - 1
return -1
```

Canonical **search insert position** (lower bound): first index `i` where `a[i] >= target` (or `n` if all smaller). That index is where you would insert to keep sorted order.

```text
lo = 0, hi = n
while lo < hi:
  mid = lo + (hi - lo) / 2
  if a[mid] < target: lo = mid + 1
  else: hi = mid
return lo
```

### Lower vs upper bound

| Name | Meaning | Typical use |
|------|---------|-------------|
| Lower bound | First index with `a[i] >= x` | Insert position; start of equal range |
| Upper bound | First index with `a[i] > x` | End of equal range (exclusive) |

First and last position of `x` in a sorted array with duplicates:

- `first = lowerBound(x)`
- `last = upperBound(x) - 1`
- If `first == n` or `a[first] != x`, not found.

### Worked binary search (four languages)

**Kotlin**

```kotlin
fun searchInsert(nums: IntArray, target: Int): Int {
    var lo = 0
    var hi = nums.size
    while (lo < hi) {
        val mid = lo + (hi - lo) / 2
        if (nums[mid] < target) lo = mid + 1 else hi = mid
    }
    return lo
}
```

**Swift**

```swift
func searchInsert(_ nums: [Int], _ target: Int) -> Int {
    var lo = 0, hi = nums.count
    while lo < hi {
        let mid = lo + (hi - lo) / 2
        if nums[mid] < target { lo = mid + 1 } else { hi = mid }
    }
    return lo
}
```

**Dart**

```dart
int searchInsert(List<int> nums, int target) {
  var lo = 0, hi = nums.length;
  while (lo < hi) {
    final mid = lo + (hi - lo) ~/ 2;
    if (nums[mid] < target) {
      lo = mid + 1;
    } else {
      hi = mid;
    }
  }
  return lo;
}
```

**TypeScript**

```typescript
function searchInsert(nums: number[], target: number): number {
  let lo = 0, hi = nums.length;
  while (lo < hi) {
    const mid = lo + ((hi - lo) >> 1);
    if (nums[mid] < target) lo = mid + 1;
    else hi = mid;
  }
  return lo;
}
```

## Why you rarely write sort on mobile

Platforms already ship battle-tested sorts:

| Language | Typical API |
|----------|-------------|
| Kotlin | `list.sort()`, `list.sortedBy { }`, `Arrays.sort` |
| Swift | `array.sort()`, `array.sorted(by:)` |
| Dart | `list.sort((a, b) => …)` |
| TypeScript | `array.sort((a, b) => …)` — **caveat below** |

Your job is:

1. Decide whether order is needed at all (maps often beat sorted lists for ID lookup).
2. Sort offline / on a background isolate / coroutine when `n` is large.
3. Write a **correct, total** comparator.
4. Prefer stable sort when equal keys must keep relative order (chat messages with same timestamp).

Implementing merge sort from scratch belongs in interviews and course homework — not in a payment SDK or a feed pipeline — unless you are merging **already-sorted** streams (see practice P3), which is a linear merge, not a full sort.

## Comparator pitfalls

1. **TypeScript default sort is lexicographic for numbers** — `[10, 2, 1].sort()` → `[1, 10, 2]`. Always pass `(a, b) => a - b` for numeric order (watch overflow for extreme ints; prefer `a < b ? -1 : a > b ? 1 : 0`).
2. **Inconsistent / non-transitive comparators** — returning random signs for equal objects can crash or infinite-loop some runtimes; never use `Random` inside compare.
3. **Comparing floats with subtraction** — NaN and −0 edge cases; prefer explicit branches.
4. **Allocating inside compare** — creating strings or date objects per comparison turns O(n log n) into a GC storm on scroll-driven re-sorts. Precompute sort keys.
5. **Unstable expectations** — if two rows share a key and you need deterministic UI order, add a tie-breaker (`id`) to the comparator.
6. **Sorting on the main thread every keystroke** — debounce; keep a sorted copy; or use a structure that supports ordered inserts if updates are frequent and small.

### Safe multi-key compare sketch (Kotlin)

```kotlin
val byTimeThenId = compareBy<Message>({ it.sentAt }, { it.id })
messages.sortWith(byTimeThenId)
```

## Merge of two sorted arrays (offline sync mental model)

After sync you often have:

- Local sorted changes by `updatedAt`
- Server page sorted by `updatedAt`

A full re-sort of the union works but wastes order you already paid for. **Two-pointer merge** produces one sorted array in O(n + m) time and teaches the same discipline as merging change-logs before publishing to the UI list.

```text
i = 0, j = 0
while both remain:
  take the smaller head, advance that pointer
append leftovers
```

When keys can collide (same timestamp), define a deterministic tie-break (local vs remote wins, or by ID) so the UI does not flicker between merges.

## Platform bridges

| Platform | Search / sort you already have |
|----------|--------------------------------|
| **Android** | `Collections.binarySearch`, `list.binarySearch`, Room/SQLite `ORDER BY` + indexes for large sets |
| **iOS** | `indexOf` linear; for sorted `ContiguousArray` roll lower-bound; Core Data / SQLite for big stores |
| **Flutter** | `list.indexWhere` linear; `binarySearch` via custom or packages; isolate for heavy sort |
| **React Native** | JS `findIndex` / `sort` on JS thread — keep n modest or move to native/SQLite |

## Common mistakes

1. Binary searching an unsorted array — undefined results, “works in tests” with lucky data.
2. Using `mid = (lo + hi) / 2` habit without care in languages with fixed-width ints (prefer `lo + (hi - lo) / 2`).
3. Returning mid on first equal when you needed the **leftmost** equal.
4. Re-sorting the entire feed for one insert instead of binary-insert or map+list hybrid.
5. Trusting TS default sort for numbers.

## Self-Check

**15.1** When is a hash map a better default than sorting + binary search for ID lookup?

**15.2** What does lower bound return for target `5` in `[1, 3, 5, 5, 7]`? Upper bound?

**15.3** Why is implementing QuickSort in app code usually the wrong move?

**15.4** What goes wrong with `numbers.sort()` in JavaScript/TypeScript without a comparator?

**15.5** How does merging two sorted change lists relate to offline sync?

*(Answers: Appendix D.)*

## Practice

1. **Search insert position** — [solutions/ch15](../../solutions/ch15/README.md#p1-search-insert-position)
2. **First and last position in sorted array** — [solutions/ch15](../../solutions/ch15/README.md#p2-first-and-last-position)
3. **Merge two sorted arrays** — [solutions/ch15](../../solutions/ch15/README.md#p3-merge-two-sorted-arrays)

Next: [Chapter 16 — Recursion and Backtracking](16-recursion-backtracking.md) — base cases, view trees, and when not to recurse on device.
