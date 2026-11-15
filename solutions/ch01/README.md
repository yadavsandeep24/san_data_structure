# Chapter 1 — Model Solutions

Model solutions for Chapter 1 practice problems. These are mindset warm-ups: one coding answer and two reasoning answers. Each names the idea, states the cost and adds a short mobile note.

Problems are defined in [`book/part-i/01-why-data-structures-matter.md`](../../book/part-i/01-why-data-structures-matter.md).

---

## P1: Membership under scroll

Given `visibleIds` (n items) and `selectedIds` (m items), return how many visible IDs are selected.

### Approach

The naive version calls `selectedIds.contains(id)` for each visible ID, which is O(n·m) because `contains` on a list is a linear scan. Build a **hash set** from `selectedIds` once (O(m)), then each membership check is O(1) on average, for O(n + m) overall.

If the same selection is checked on every frame, keep the set **as the source of truth** for selection state (Chapter 8) rather than rebuilding it on every bind.

### Complexity

- Time: O(n + m) average (vs O(n·m))
- Space: O(m) for the set

### Edge cases

- Empty selection → 0, and no set needs building
- Duplicate IDs in `visibleIds`: each occurrence is counted (dedupe first if the rows are unique by definition)
- Duplicate IDs in `selectedIds`: the set ignores them

### Mobile note

With 2,000 rows and 200 selected IDs, the list scan is ~400k string comparisons per full rebind, which can take tens of milliseconds and drop frames. The set version is ~2,000 hash lookups, well under a millisecond.

### Kotlin

```kotlin
fun countSelectedVisible(visibleIds: List<String>, selectedIds: List<String>): Int {
    val selected = selectedIds.toHashSet()          // O(m)
    return visibleIds.count { it in selected }      // O(n), O(1) average per check
}
```

### Swift

```swift
func countSelectedVisible(_ visibleIds: [String], _ selectedIds: [String]) -> Int {
    let selected = Set(selectedIds)
    return visibleIds.reduce(0) { $0 + (selected.contains($1) ? 1 : 0) }
}
```

### Dart

```dart
int countSelectedVisible(List<String> visibleIds, List<String> selectedIds) {
  final selected = selectedIds.toSet();
  return visibleIds.where(selected.contains).length;
}
```

### TypeScript

```typescript
function countSelectedVisible(visibleIds: string[], selectedIds: string[]): number {
  const selected = new Set(selectedIds);
  let count = 0;
  for (const id of visibleIds) if (selected.has(id)) count++;
  return count;
}
```

---

## P2: Thread placement

Screen: download a 5 MB JSON catalog, then show a searchable list.

### Answer

| Step | Thread | Why |
|------|--------|-----|
| Network fetch | Background (OkHttp/Ktor dispatcher, `URLSession`, Dart `http`, RN networking) | I/O must never block the UI thread. Android throws `NetworkOnMainThreadException`. |
| JSON parse (5 MB) | **Background**: `Dispatchers.Default`, a detached `Task` / background actor, `Isolate.run` / `compute`, or native parsing off the JS thread | O(n) work with heavy allocation, which can take 50–200 ms on mid-range devices. |
| Build the search index | **Background**, once | For example a `Map<normalizedPrefix, List<id>>` or a trie (Chapter 10), or simply lowercased names stored next to each item, so each keystroke does no string normalization. |
| Persist to disk cache | Background | Disk I/O. Lets the next launch skip the network (Chapter 18). |
| Hand the list to the UI | Main thread, **one** state update | Publish an immutable list plus index. Avoid streaming thousands of tiny updates. |
| Per-keystroke filter | Main thread **only if** it's cheap (index lookup, O(results)), and debounced (~150–300 ms) | A linear scan of 10k items per keystroke belongs on a background thread, with stale results cancelled. |

### Structure to build once

A list of items in display order plus a lookup structure for search: a prefix map or trie for "starts with", or precomputed lowercase keys for "contains". Build it off the main thread, keep it with the list in your state holder (ViewModel / ObservableObject / Riverpod provider / store), and swap the pair in together.

### Mobile note

The rule of thumb is that **anything O(n) over a large n, or anything that allocates heavily, runs off the UI thread**. The UI thread only gets O(1) or O(visible) work per frame.

---

## P3: Budget math

A membership check costs about 50 ns. How many fit in 8 ms, and what does that mean at 120 Hz?

### Answer

- 8 ms = 8,000,000 ns → 8,000,000 / 50 = **160,000 checks** in theory.
- At 120 Hz a frame is ~8.33 ms, but you never get all of it. Layout, drawing, the GPU handoff and the framework itself take most of the frame. Plan on **a few milliseconds at most** for your own per-frame logic, which is tens of thousands of cheap checks, not hundreds of thousands.
- So O(1) checks per visible row (say 20 rows × a few checks) are trivially safe. An O(n) scan per row (n = 10k, so 200k checks for 20 rows) is **already over budget** before you count anything else.

### Takeaway

Big-O tells you how cost grows. The frame budget tells you where the ceiling is. At 120 Hz the ceiling halves compared with 60 Hz, so per-frame work has to stay at O(1) or O(visible).
