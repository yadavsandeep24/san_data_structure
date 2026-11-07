# Chapter 3 — Arrays and Dynamic Arrays

Open any mobile app and you are staring at arrays wearing costumes: chat timelines, product grids, settings rows, notification inboxes. `RecyclerView`, `UITableView`, Flutter’s `ListView.builder`, and React Native’s `FlatList` all assume you can address the *i*-th model quickly. That assumption is the array’s gift — and its front-insert cost is the tax you pay when you misuse it.

This chapter covers fixed vs dynamic arrays, growth, per-language list semantics, cache locality, and the two practice problems every mobile engineer should be able to write cold.

---

## Motivation: when the list backbone fights you

Symptoms tied to array misuse:

| Symptom | Likely array mistake |
|---------|----------------------|
| Jank while prepending to a timeline | Insert-at-front is O(n); doing it repeatedly is brutal |
| Spiky memory during load | Dynamic growth + copies; holding multiple full duplicates |
| Smooth scroll that dies after mutate | Diffing against a huge array with O(n²) identity checks |
| OOM on image-heavy grids | Array of full bitmaps instead of IDs + cache |

List widgets recycle **views**. They do not recycle your mistakes in the **model array**. Index O(1) keeps bind cheap; shifting thousands of elements on the main thread does not.

---

## Concept: fixed vs dynamic

A **fixed array** has a length chosen up front. Index read/write is O(1). You cannot grow without allocating a new buffer and copying.

A **dynamic array** (resizable list) stores `size` and `capacity`. When size would exceed capacity, it allocates a larger buffer (often ~2×), copies elements, and continues. Amortized append is O(1); a single growth spike is O(n).

### Operation costs (dynamic array / ArrayList-style)

| Operation | Time | Notes |
|-----------|------|-------|
| Get / set by index | **O(1)** | Core reason lists feel fast |
| Append at end | **O(1)** amortized | Occasional O(n) resize |
| Insert / remove at end | **O(1)** amortized | |
| Insert / remove at front or middle | **O(n)** | Must shift elements |
| Search by value (unsorted) | **O(n)** | Linear scan |
| Space | **O(capacity)** | Capacity ≥ size; waste is normal |

### Why growth is geometric

Doubling capacity makes the **amortized** cost of n appends Θ(n). If you grew by +10 each time, total copy cost would be quadratic. Mobile lesson: prefer one correctly sized `ArrayList(capacity)` / reserved `ContiguousArray` when you know the count from a network payload.

### Cache locality

Elements sit in contiguous memory. Scanning an array plays well with CPU caches — often faster in practice than a linked list with the same Big-O for iteration. That is why arrays remain the default backbone for UI lists even when linked lists look elegant on a whiteboard.

---

## Platform bridges

| Idea | Android (Kotlin) | iOS (Swift) | Flutter (Dart) | React Native (TS) |
|------|------------------|-------------|----------------|-------------------|
| Dynamic list | `ArrayList` / `mutableListOf` | `Array` / `ContiguousArray` | `List` / `Growable` list | `Array` (`[]`) |
| Fixed buffer | `Array(n) { }` | `Array(repeating:count:)` | fixed via typed data / careful use | `TypedArray` / pre-sized rare |
| UI backbone | `RecyclerView` + `ListAdapter` (Views) / `LazyColumn` (Compose) | `UITableView` / `DiffableDataSource` | `ListView.builder` | `FlatList` |
| Prefer for UI models | random access by index | same | same | same |

**Android:** `ArrayList` is the workhorse; `arrayOf` is fixed-size (but still reference cells). Prefer `listOf` / immutability at the UI boundary after background prep.

**iOS:** `Array` is value-semantic with copy-on-write; large in-place mutations of shared arrays can surprise you with copies — know when you uniquely reference the buffer.

**Flutter:** `List` is growable by default (`[]`). `List.filled` / `List.generate` create fixed-length lists that throw if you `add`.

**React Native:** JS arrays are dynamic. For `FlatList`, keep `data` as a stable array reference when contents unchanged; mutate immutably for React reconciliation (`[...arr, x]` trades clarity for allocation).

---

## Worked code: append vs insert front

### Kotlin

```kotlin
val end = ArrayList<Int>(4)
end.add(1)          // O(1) amortized
end.add(0, 99)      // O(n) — shifts right

val frontHeavy = ArrayDeque<Int>() // better for front ops — Chapter 6
```

### Swift

```swift
var end = [Int]()
end.append(1)                 // O(1) amortized
end.insert(99, at: 0)         // O(n)

var reserved: [Int] = []
reserved.reserveCapacity(10_000) // avoid repeated growth copies
```

### Dart

```dart
final end = <int>[];
end.add(1);                   // O(1) amortized
end.insert(0, 99);            // O(n)

final fixed = List<int>.filled(3, 0); // fixed length
// fixed.add(1); → throws
```

### TypeScript

```typescript
const end: number[] = [];
end.push(1);                  // O(1) amortized
end.unshift(99);              // O(n) — avoid in hot paths
```

**Label the habit:** building a timeline by `insert(0, …)` for every page is O(n²) overall. Append chronologically then reverse once, or use a structure suited to front insert.

---

## Arrays as list UI backbone

Typical bind path (all platforms):

1. Adapter/builder asks for item at index `i` — **O(1)** array get.
2. Bind fields to a recycled view/widget — should be O(1) field reads.
3. On data change, compute a diff (ideally O(n) with good keys) and dispatch minimal inserts/removes.

If step 2 calls `selected.contains(id)` on a list, you reintroduce Chapter 1’s nested cost. Keep the model array for order; keep a `Set` for membership; keep maps for ID → index when you must jump.

---

## Common mistakes

1. **Prepend in a loop** — classic O(n²) inbox construction.
2. **Using arrays for mid-list deletes at scale** — each remove shifts; batch or rethink representation.
3. **Ignoring capacity** — parsing 50k JSON objects into a default-growth list causes repeated copies and GC churn.
4. **Mutating the array FlatList/RecyclerView is iterating** without a coherent diff — crashes or blank frames. (Compose's `LazyColumn` fails differently: an in-place mutation of a plain list is simply not observed — publish a new list.)
5. **Storing heavy objects** (bitmaps, full subgraphs) directly in the scrolling array — store IDs, cache payloads elsewhere (Chapter 12).

---

## Self-Check

Answers in Appendix D.

3.1 Why is append amortized O(1) but insert-at-zero O(n) on a dynamic array?

3.2 What does geometric capacity growth buy you compared to growing by a constant amount?

3.3 True or false: `ListView.builder` / `FlatList` make random access of your model O(1) even if you stored models in a linked list.

3.4 Why might `reserveCapacity` / sizing an `ArrayList` with an expected count reduce jank during load?

3.5 Name one reason contiguous layout helps mobile list scrolling beyond Big-O labels.

---

## Practice Problems

Full model solutions (Kotlin, Swift, Dart, TypeScript), complexity, edge cases, and mobile notes:

→ **[`solutions/ch03/README.md`](../../solutions/ch03/README.md)**

1. **Remove duplicates, preserve order** — Given an array of IDs, return a new sequence with first occurrences only. Target **O(n)** time with a hash set for seen values.
2. **Rotate array right by k** — Rotate in place or via a clean O(n) / O(1) extra approach; handle `k > n` and empty input.

Attempt both on paper first, then compare with the model solutions. Run a mental check: would your solution be safe to call on the main thread for n = 20 vs n = 200,000?

---

## What to remember

Arrays give O(1) indexing and excellent locality — the right backbone for almost every scrollable UI. Dynamic arrays make append cheap amortized and front mutation expensive. Size capacity when you know n, never prepend in a hot loop, and pair the ordered array with sets/maps for membership and lookup. Next chapters contrast this with linked lists and stacks — tools for when order of growth at the ends matters more than index speed.
