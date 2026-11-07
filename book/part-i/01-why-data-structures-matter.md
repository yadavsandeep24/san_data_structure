# Chapter 1 — Why Data Structures Matter for Mobile Developers

A contacts screen that freezes when you type one letter. A feed that scrolls like wet cement after a few minutes. An app that gets killed mid-session on a mid-range Android phone while the same build feels fine on a flagship. These are not mysterious framework bugs. They are what happens when the wrong structure does too much work on the wrong thread inside a frame budget that is only about sixteen milliseconds long.

This chapter is the why. Before Big-O tables and interview patterns, you need a mobile intuition: memory is scarce, the main thread is sacred, and the structure you pick decides whether the UI stays at 60fps or drops frames users can feel.

---

## Motivation: failure modes you already ship

Mobile runtimes punish waste differently than servers do.

| Failure | What the user feels | Typical structural cause |
|---------|---------------------|--------------------------|
| **Jank** | Stutter while scrolling or typing | O(n²) work, or any heavy scan, on the UI thread |
| **OOM / jetsam** | Sudden kill, “app closed itself” | Unbounded lists/caches; copies of copies of bitmaps/JSON |
| **Battery heat** | Warm phone, drain while idle | Tight loops, repeated allocations, polling instead of events |
| **ANR / watchdog** | Freeze, then system dialog | Blocking I/O or long CPU on the main thread |

On a 60Hz display you get roughly **16.67ms** per frame for layout, draw, and your own logic. On 120Hz that shrinks toward **8.3ms**. If your “is this contact already selected?” check scans a growing array on every keystroke, you are spending the frame budget on membership tests instead of pixels.

The right data structure does not make your app “clever.” It keeps the hot path cheap enough that the compositor never notices you were there.

---

## Concept: structure is a contract with cost

A **data structure** is a way to organize values so that some operations are fast and others are slow. Arrays give O(1) index access and bad front inserts. Hash sets give average O(1) membership and no stable order unless you add one. Trees trade contiguous cache friendliness for logarithmic search with ordering.

You choose a structure the way you choose a tool: by the operations that dominate the screen.

### Complexity at a glance (preview)

You will formalize this in Chapter 2. For now, treat these as engineering labels, not math ceremony:

| Operation pattern | Rough cost | Mobile smell |
|-------------------|------------|--------------|
| Touch one index | O(1) | Safe on UI if the work itself is tiny |
| Scan all n items once | O(n) | OK off UI; risky on UI if n is large or called often |
| Nested scan of n × n | O(n²) | Almost never OK on UI for user-facing lists |
| Hash membership | O(1) average | Prefer when “contains?” is hot |

**Space** matters as much as time on devices. An extra HashSet of IDs is often cheaper than the jank of rescanning, but an unbounded cache of full models is how you earn memory pressure kills.

---

## Platform bridges

Same idea, different names — and different places where the UI thread lives.

| Concern | Android | iOS | Flutter | React Native |
|---------|---------|-----|---------|--------------|
| UI / main thread | Main thread / main looper | Main thread | UI isolate | JS thread + UI thread |
| Contiguous list | `Array` / `ArrayList` | `Array` / `ContiguousArray` | `List` | `Array` / `[]` |
| Fast membership | `HashSet` / `LinkedHashSet` | `Set` | `Set` | `Set` |
| List UI backbone | `RecyclerView` (Views) / `LazyColumn` (Compose) | `UITableView` / `UICollectionView` | `ListView` / `ListView.builder` | `FlatList` / `FlashList` |

**Android:** Work that touches views must stay on the main thread; CPU-heavy prep belongs on Dispatchers.Default / a background executor, then post results back.

**Android, both toolkits:** In the View system the hot path is `onBindViewHolder`; in Jetpack Compose it is the composable body, which can re-run on every recomposition. Both run on the main thread, so the same rule holds: build the `Set`/`Map` once (in the ViewModel, or `remember(inputs) { … }` in Compose) and do only O(1) lookups per row.

**iOS:** Same rule with GCD or Swift Concurrency — never block the main actor with linear scans of large arrays during scroll or search.

**Flutter:** Dart UI work runs on the UI isolate. Heavy parsing or dedupe should move to a worker isolate; still choose O(1) structures for what remains on the UI isolate.

**React Native:** JS is single-threaded. A nested loop in a `onChangeText` handler stalls gestures and bridge traffic even if native UI is “fine.”

---

## Worked example: nested loop vs HashSet membership

Scenario: a multi-select picker. You already have `selectedIds`. For each row you ask “is this id selected?” to draw a checkmark. With an array, each row may scan the whole selection list — nested work. With a set, each row is roughly constant time.

### Kotlin

```kotlin
// BAD — O(n * m) if you do this for every row (n = rows, m = selected size)
fun isSelectedSlow(id: String, selected: List<String>): Boolean {
    for (s in selected) {          // O(m) per call
        if (s == id) return true
    }
    return false
}

// GOOD — build once O(m), then each lookup O(1) average
fun buildSelectedSet(selected: List<String>): Set<String> =
    selected.toHashSet()           // O(m)

fun isSelectedFast(id: String, selectedSet: Set<String>): Boolean =
    selectedSet.contains(id)       // O(1) average
```

### Swift

```swift
// BAD — linear membership repeated per row
func isSelectedSlow(_ id: String, selected: [String]) -> Bool {
    for s in selected {            // O(m)
        if s == id { return true }
    }
    return false
}

// GOOD
func buildSelectedSet(_ selected: [String]) -> Set<String> {
    Set(selected)                  // O(m)
}

func isSelectedFast(_ id: String, selectedSet: Set<String>) -> Bool {
    selectedSet.contains(id)       // O(1) average
}
```

### Dart

```dart
// BAD
bool isSelectedSlow(String id, List<String> selected) {
  for (final s in selected) {      // O(m)
    if (s == id) return true;
  }
  return false;
}

// GOOD
Set<String> buildSelectedSet(List<String> selected) =>
    selected.toSet();              // O(m)

bool isSelectedFast(String id, Set<String> selectedSet) =>
    selectedSet.contains(id);      // O(1) average
```

### TypeScript

```typescript
// BAD — avoid inside FlatList renderItem / onChangeText
function isSelectedSlow(id: string, selected: string[]): boolean {
  for (const s of selected) {      // O(m)
    if (s === id) return true;
  }
  return false;
}

// GOOD
function buildSelectedSet(selected: string[]): Set<string> {
  return new Set(selected);        // O(m)
}

function isSelectedFast(id: string, selectedSet: Set<string>): boolean {
  return selectedSet.has(id);      // O(1) average
}
```

**Mobile note:** Build the `Set` once when selection changes (or when the screen loads), not inside every cell’s bind method. Keep the build off the critical path if `m` is huge; keep lookups on the UI thread only if they stay tiny.

If you render 2,000 rows and average 200 selected IDs, the slow path can touch on the order of **400,000** comparisons per full bind. The set path touches roughly **2,000** hash lookups after a one-time build. That difference is the gap between “smooth” and “why is search lagging?”

---

## UI thread vs background thread

Rules of thumb that save careers:

1. **UI thread:** bind already-prepared data, apply diffs, start animations, respond to input. Prefer O(1) / O(log n) micro-work.
2. **Background:** parse JSON, build indexes, dedupe, sort, filter large lists, decode images.
3. **Hand-off:** publish an immutable snapshot (or a small delta) to the UI — do not share a mutating ArrayList across threads without synchronization.

Data structures enable this split. A background thread can afford an O(n log n) sort; the UI thread usually cannot afford an O(n²) “merge visible with selected” on every scroll tick.

---

## Memory and battery, not just frames

- **Copies:** mapping a list into another list into another list allocates. On mobile, allocation pressure causes GC/ARC churn and frame hiccups even when Big-O looks fine.
- **Retention:** holding every chat message object forever is a structure problem (unbounded list) as much as a product problem.
- **Wakeups:** busy-waiting or rescanning a queue every 50ms burns battery; a proper queue + event wakes you when work arrives.

Choosing a HashMap for an ID → model index can *reduce* battery use by ending repeated full scans — fewer CPU cycles, cooler silicon.

---

## Common mistakes

1. **Linear `contains` on hot paths** — search bars, filters, “already downloaded?” checks.
2. **Doing “just one more pass” on the main thread** — three O(n) passes per keystroke still lose the 16ms budget at large n.
3. **Premature micro-optimization of cold paths** — optimize the structure on the screen’s hot path first.
4. **Assuming flagship performance** — test mid-tier Android and older iPhones; O(n²) fails there first.
5. **Confusing “framework list widget” with “efficient data model”** — `RecyclerView` / `LazyColumn` / `FlatList` only recycle (or lazily compose) rows; they do not fix O(n²) data prep.

---

## Self-Check

Answers in Appendix D.

1.1 Why is a 16ms frame budget relevant when choosing between an array scan and a hash set for membership?

1.2 Give one example of work that belongs on a background thread even if its asymptotic cost is only O(n).

1.3 True or false: using a `Set` for selected IDs always uses less memory than a `List`.

1.4 In React Native, why can a nested loop in JS still cause jank even when native list views are recycling cells?

1.5 What does it mean that a data structure is a “contract with cost”?

---

## Practice Problems

Warm-ups for the mindset (full model solutions appear with later chapters’ folders as you progress; Chapter 3’s array drills live under [`solutions/ch03/`](../../solutions/ch03/README.md)).

1. **Membership under scroll** — Given `visibleIds: List<String>` and `selectedIds: List<String>`, return how many visible IDs are selected. Aim for better than O(n·m). Sketch in your primary language, then compare to a set-based approach.
2. **Thread placement** — For a screen that downloads a 5MB JSON catalog then shows a searchable list, list which steps must not run on the UI thread and which structure you would build once for search.
3. **Budget math** — If a membership check costs ~50ns on a device, roughly how many such checks fit in 8ms? What does that imply for per-frame work at 120Hz?

---

## What to remember

Users feel structures as smoothness. Keep the UI thread on cheap operations, move heavy preparation off-thread, prefer hash-backed membership when “contains?” is hot, and treat memory as a first-class constraint. Chapter 2 turns these instincts into the vocabulary of Big-O so you can predict cost before the profiler yells.
