# Chapter 2 — Model Solutions

Model answers for Chapter 2 practice problems. These are complexity-reading exercises, so the answers are reasoning plus small code where it helps.

Problems are defined in [`book/part-i/02-big-o-notation.md`](../../book/part-i/02-big-o-notation.md).

---

## P1: Read the cost

State time and extra space for each snippet.

### (a) One loop pushing into a new array

```kotlin
fun doubled(a: List<Int>): List<Int> {
    val out = ArrayList<Int>(a.size)   // presizing avoids regrowth
    for (x in a) out.add(x * 2)
    return out
}
```

- **Time:** Θ(n). Each `add` is amortized O(1). Without presizing it is still amortized O(1), but with occasional O(n) copies during regrowth (Chapter 3).
- **Extra space:** Θ(n) for the output.

### (b) Loop with `list.contains`

```kotlin
fun commonNaive(a: List<String>, b: List<String>): List<String> =
    a.filter { b.contains(it) }        // contains is a linear scan of b
```

- **Time:** Θ(n·m). The hidden loop is inside `contains`.
- **Extra space:** O(k) for the result.
- **Fix:** `val set = b.toHashSet(); a.filter { it in set }` → Θ(n + m) time, O(m) extra space.

### (c) Sort, then a single pass

```kotlin
fun hasDuplicateBySort(a: IntArray): Boolean {
    val s = a.sortedArray()             // copy + sort
    for (i in 1 until s.size) if (s[i] == s[i - 1]) return true
    return false
}
```

- **Time:** Θ(n log n) for the sort. The pass is Θ(n), which the sort dominates.
- **Extra space:** Θ(n) for the sorted copy (O(log n) or less extra if sorting in place is allowed, but mutating the caller's array is a side effect).
- **Alternative:** a hash set gives Θ(n) average time with Θ(n) space. Sorting wins when memory is tight or the data must be sorted anyway.

### Mobile note

Always name the **hidden** costs: library calls (`contains`, `indexOf`, `remove(0)`), copies (`sorted()` vs `sort()`), and allocations per iteration.

---

## P2: Budget call

A search box filters 10,000 rows on every keystroke, on the JS/UI thread, with a linear scan.

### Diagnosis

Each keystroke costs Θ(n · L) (n rows, L = string length for `includes` / `contains`). That runs several times a second while typing, on the same thread that handles input and animation. Result: input lag and dropped frames, worst on low-end Android.

### Redesign (apply in this order)

1. **Debounce** input by ~150–300 ms so the scan runs once per pause, not once per character.
2. **Precompute normalized keys once** (lowercase, accents stripped) when the data loads, so each keystroke doesn't call `toLowerCase()` 10,000 times.
3. **Index for the query type:**
   - "Starts with": a sorted array of keys plus binary search for the range (Chapter 21), or a trie (Chapter 10). Θ(log n + results) or Θ(L + results).
   - Token / word prefix: a map from token prefix to an ID list, built once.
   - "Contains anywhere": an n-gram index, or accept a linear scan **off the main thread**.
4. **Move the work off the UI thread** if it is still linear: a background coroutine / `Task` / isolate / JS worker or native module. Cancel stale searches when a new keystroke arrives.
5. **Incremental narrowing:** if the new query extends the previous one, filter the previous *results* instead of all n rows.
6. **Render only what's visible** (`FlatList` / `LazyColumn` / `ListView.builder`) with stable keys, so the diff stays O(changed).

### Complexity after

Per keystroke: Θ(log n + results) with a sorted or trie index, and none of it blocks the UI thread. Setup is Θ(n log n) or Θ(total characters), paid once off the main thread.

---

## P3: Space first

Name a feature where reducing space matters more than shaving a log n factor in time.

### Strong answers

- **Image memory cache.** A decoded 1080×1920 ARGB bitmap is ~8 MB. An LRU cache bounded by **bytes** (Chapter 18) matters far more than whether lookup is O(1) or O(log n). Exceeding memory gets the app killed (jetsam / low-memory killer), which is worse than any slow lookup.
- **Offline map tiles or a large on-device dataset.** A compact sorted array plus binary search (O(log n), minimal overhead) can beat a hash map that uses 2–3× the memory per entry, especially on 2–3 GB devices.
- **Keyboard / IME extensions and widgets.** iOS keyboard extensions and widgets have tight memory caps (tens of MB). A compact trie or sorted word list wins over a large hash map even if it is a bit slower.
- **Undo history** in an editor. Store diffs or commands (O(change)) rather than full document snapshots (O(document) each).

### Why

On a phone, **running out of memory is fatal**: the process is killed and the user's state is lost. A slightly slower lookup is invisible. When both fit the time budget, choose the smaller footprint.
