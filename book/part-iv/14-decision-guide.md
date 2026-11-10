# Chapter 14 — Choosing the Right Structure — Decision Guide

Parts II–IV gave you tools: arrays, linked lists, stacks, queues, hash tables, sets, trees, graphs, caches, and list diffs. Interviews and production both punish the same mistake: grabbing the first collection that compiles. This chapter is a pocket decision guide — a flowchart, a cheat sheet, and the failure modes that quietly slow mobile apps.

---

## Mobile motivation

You rarely get a prompt that says “use a deque.” You get: “autocomplete should stay smooth,” “don’t download the avatar twice,” “back should return to the same scroll position,” “detect whether this SKU is already in the cart.” The structure is implied by the **dominant operation** and the **thread** that runs it.

Ask, in order:

1. What is the hot operation? (lookup, ordered scan, ends only, nested hierarchy, relationships)
2. How large is n on a bad day? (100 vs 100,000)
3. Is this on the UI thread?
4. Do I need bounded memory (cache) or exact growth (buffer)?

---

## Flowchart

```mermaid
flowchart TD
  start([What is the dominant need?]) --> q1{Fast membership or keyed lookup?}
  q1 -->|Yes| lookup[HashMap / HashSet / Dictionary]
  q1 -->|No| q2{Ordered sequence with index access?}
  q2 -->|Yes| seq[Dynamic array / List]
  q2 -->|No| q3{Only care about ends — LIFO or FIFO?}
  q3 -->|LIFO| stack[Stack]
  q3 -->|FIFO / both ends| deque[Queue / Deque]
  q3 -->|No| q4{Hierarchy or parent/child?}
  q4 -->|Yes| tree[Tree / trie]
  q4 -->|No| q5{Relationships / paths / many-to-many?}
  q5 -->|Yes| graph[Graph]
  q5 -->|No|   q6{Frequent insert/delete in the middle — and you already hold the node?}
  q6 -->|Yes| linked[Linked list — rare on mobile]
  q6 -->|No| hybrid[Compose: array + set/map]

  lookup --> cacheNote[If bounded + eviction: LRU/TTL cache]
  seq --> listNote[If UI list: stable IDs + diff]
  hybrid --> hybridNote[Array for order, Set for contains]
```

**Reading tip:** many real screens need **hybrids**. A cart is an array (order) plus a set/map (membership and line lookup). A feed is an array plus a set (dedupe) plus a cursor. A cache is a map plus a linked list (LRU).

---

## Cheat sheet — situation → structure

| Situation | Reach for | Avoid |
|-----------|-----------|-------|
| “Is this ID selected / in cart / already loaded?” | `HashSet` / `Set` | Scan an array each row |
| “Get user by id” | `HashMap` / `Dictionary` | Linear search |
| Scrollable feed / results | Dynamic array + stable IDs | Linked list as UI backbone |
| Patch one feed row by id | `Map<id, index>` or map of models | Scan to find index every time |
| Navigation back | Stack | Queue |
| Undo / redo | Two stacks | Single array without redo policy |
| Upload / request scheduling | Queue / deque | Recursive fire-and-forget |
| Sliding window max / rate limit timestamps | Deque | Re-sort every event |
| Autocomplete prefix | Trie (or sorted array + binary search) | Nested loops on every keystroke |
| Image / API response reuse | LRU (+ TTL) memory, optional disk | Unbounded map |
| File system / widget tree style data | Tree | Flattened array without parent links when you need subtree ops |
| Social follow graph / deep links between entities | Graph | Ad-hoc nested arrays only |
| Mid-list insert when you already hold the node (rare) | Linked list | Usually still array batching wins |
| Ordered unique IDs | LinkedHashSet / ordered set | List + manual dedupe scans |
| Time-ordered events with eviction | Queue / ring buffer | Infinite log on device |

---

## Complexity reminders (mobile-sized)

| Structure | Get by key/index | Insert at end | Insert front | Membership |
|-----------|------------------|---------------|--------------|------------|
| Dynamic array | O(1) index | Amortized O(1) | O(n) | O(n) |
| Hash map/set | O(1) avg key | O(1) avg | N/A | O(1) avg |
| Stack / deque (ends) | O(1) peek | O(1) | O(1) at ends | O(n) |
| Singly linked list | O(n) | O(1) at head | O(1) head | O(n) |
| Balanced tree map | O(log n) | O(log n) | O(log n) | O(log n) |
| LRU cache | O(1) | O(1) | N/A | O(1) |

On device, **constants and locality** matter: arrays beat node-pointer structures for scan-heavy UI. Prefer hash sets over tree sets unless you need ordered keys.

---

## Common mistakes that slow apps

1. **Membership via `list.contains` in `bind` / `renderItem`** — O(n) per row → O(n²) per frame.
2. **Prepend in a loop** to build a timeline — O(n²) allocations and copies.
3. **`notifyDataSetChanged` / `reloadData` / index keys / `LazyColumn` without `key`** — full rebind, lost state, image flicker (Chapter 13).
4. **Unbounded caches** of bitmaps or JSON — jetsam / OOM (Chapter 12).
5. **Heavy work on the UI thread** — even O(n) can jank at n = 50k; move parse/diff off main.
6. **Linked lists as the RecyclerView/LazyColumn/FlatList backbone** — no O(1) index; builders become O(n²).
7. **New `Set` built inside every row** instead of once per frame — allocation storm.
8. **Offset pagination** for live feeds — duplicates and gaps under inserts.
9. **Deep recursion** on untrusted depth — prefer explicit stacks (Chapter 5).
10. **Holding UI references in caches / undo commands** — leaks and crashes after rotation.

---

## Platform bridges — “what do I type?”

| Need | Kotlin | Swift | Dart | TypeScript |
|------|--------|-------|------|------------|
| Ordered buffer | `ArrayList` / `mutableListOf` | `Array` | `List` | `Array` / `[]` |
| Membership | `HashSet` | `Set` | `Set` | `Set` |
| Key-value | `HashMap` | `Dictionary` | `Map` | `Map` / object |
| Stack | `ArrayDeque` | `Array` as stack | `List` | `Array` |
| Queue | `ArrayDeque` | head-index array | `Queue` | head-index / deque lib |
| LRU | `LinkedHashMap` access-order / `LruCache` | `NSCache` / hand-rolled | packages / hand-rolled | `Map` insertion order |

---

## Worked examples

### Hybrid cart (array + map)

**Requirement:** show line items in add-order; “Add” must O(1) detect existing SKU and increment qty.

**Kotlin**

```kotlin
class Cart {
    private val order = mutableListOf<String>()           // sku order
    private val qty = HashMap<String, Int>()              // sku → count

    fun add(sku: String) {
        val n = qty[sku] ?: 0
        if (n == 0) order.add(sku)
        qty[sku] = n + 1
    }

    fun contains(sku: String) = qty.containsKey(sku)      // O(1)
    fun lines(): List<Pair<String, Int>> = order.map { it to qty.getValue(it) }
}
```

**Swift**

```swift
final class Cart {
    private var order: [String] = []
    private var qty: [String: Int] = [:]

    func add(_ sku: String) {
        let n = qty[sku] ?? 0
        if n == 0 { order.append(sku) }
        qty[sku] = n + 1
    }

    func contains(_ sku: String) -> Bool { qty[sku] != nil }

    func lines() -> [(String, Int)] {
        order.map { ($0, qty[$0]!) }
    }
}
```

**Dart**

```dart
class Cart {
  final _order = <String>[];
  final _qty = <String, int>{};

  void add(String sku) {
    final n = _qty[sku] ?? 0;
    if (n == 0) _order.add(sku);
    _qty[sku] = n + 1;
  }

  bool contains(String sku) => _qty.containsKey(sku);

  List<(String, int)> lines() =>
      [for (final s in _order) (s, _qty[s]!)];
}
```

**TypeScript**

```typescript
class Cart {
  private order: string[] = [];
  private qty = new Map<string, number>();

  add(sku: string): void {
    const n = this.qty.get(sku) ?? 0;
    if (n === 0) this.order.push(sku);
    this.qty.set(sku, n + 1);
  }

  contains(sku: string): boolean {
    return this.qty.has(sku);
  }

  lines(): [string, number][] {
    return this.order.map((s) => [s, this.qty.get(s)!]);
  }
}
```

### Recent-search list (capacity k, MRU display)

Keep the last *k* unique queries for a search screen. Re-adding a term bumps it to newest; dequeue from the front when over capacity. Use a set for membership. `list()` returns **most-recent-first** for chip UI. Prefer a head-index queue so front removal stays O(1) amortized (Chapter 6); duplicate bump via `indexOf`/`splice` is O(k) — production uses doubly linked list + map.

**Kotlin**

```kotlin
class RecentSearches(private val k: Int) {
    private val q = mutableListOf<String>()
    private var head = 0
    private val seen = HashSet<String>()

    fun add(term: String) {
        if (term in seen) {
            val i = q.subList(head, q.size).indexOf(term)
            if (i >= 0) q.removeAt(head + i)
        } else {
            seen += term
        }
        q += term
        while (q.size - head > k) {
            seen -= q[head++]
        }
    }

    fun list(): List<String> = q.subList(head, q.size).reversed()
}
```

**Swift**

```swift
final class RecentSearches {
    private var q: [String] = []
    private var head = 0
    private var seen = Set<String>()
    private let k: Int

    init(k: Int) { self.k = k }

    func add(_ term: String) {
        if seen.contains(term) {
            if let i = q[head...].firstIndex(of: term) { q.remove(at: i) }
        } else {
            seen.insert(term)
        }
        q.append(term)
        while q.count - head > k {
            seen.remove(q[head])
            head += 1
        }
    }

    func list() -> [String] { Array(q[head...].reversed()) }
}
```

**Dart**

```dart
class RecentSearches {
  RecentSearches(this.k);
  final int k;
  final _q = <String>[];
  var _head = 0;
  final _seen = <String>{};

  void add(String term) {
    if (_seen.contains(term)) {
      final i = _q.indexOf(term, _head);
      if (i >= 0) _q.removeAt(i);
    } else {
      _seen.add(term);
    }
    _q.add(term);
    while (_q.length - _head > k) {
      _seen.remove(_q[_head++]);
    }
  }

  List<String> list() => _q.sublist(_head).reversed.toList();
}
```

**TypeScript**

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

  list(): string[] {
    return this.q.slice(this.head).reverse();
  }
}
```

---

## Compose patterns (cheat within a cheat sheet)

*“Compose” here means composing data structures, not Jetpack Compose — the Android toolkit split is in the next table.*

| UI feature | Composition |
|------------|-------------|
| Multi-select list | Array of rows + Set of selected IDs |
| Feed with likes | Array of posts + Map id→index (or id→model) + Set for dedupe on page merge |
| Offline-first reader | Disk cache + memory LRU + array of IDs for the list |
| Tab + back navigation | Stack per tab (or single stack with tab ids) |
| Typeahead | Trie or sorted array; results as array; selection Set optional |

### Same composition, both Android toolkits

The data structure is decided in the ViewModel; the View system and Jetpack Compose only differ in where you plug it in.

| UI feature | Views (XML + `RecyclerView` / Fragments) | Jetpack Compose |
|------------|------------------------------------------|-----------------|
| Multi-select list | Adapter receives `Set<String>`; `notifyItemChanged(i, payload)` on toggle | Row gets `checked = id in selectedIds`; only toggled rows recompose |
| Feed with likes | `ListAdapter` + `DiffUtil.ItemCallback` (+ payload for the like) | `LazyColumn` `items(key = { it.id })` + immutable models |
| Offline-first reader | Shared image loader into `ImageView` | Same loader via `AsyncImage` |
| Tab + back navigation | `FragmentManager` / Navigation component back stack; `OnBackPressedCallback` | `NavController` back stack; `BackHandler` |
| Typeahead | Results `submitList`ed; trie built off main | Results as state; trie built off main, not in the composable body |

If you only remember one sentence from Part IV: **arrays show order; sets and maps answer “is it / where is it?” in O(1); caches bound memory; diffs protect the UI.**

---

## Self-Check

Answers in Appendix D.

**14.1** A multi-select list checks selection per row while scrolling. Array or Set for `selectedIds`? Why?

**14.2** When is a linked list the wrong backbone for a Flutter `ListView.builder`?

**14.3** Name a situation that needs array + set together.

**14.4** What question in the flowchart leads you to a stack rather than a queue?

**14.5** Why does “HashMap is O(1)” still fail as an image cache without eviction?

---

## Practice Problems

Full model solutions:

→ **[`solutions/ch14/README.md`](../../solutions/ch14/README.md)**

1. **Five scenario prompts** — For each, pick a structure (or hybrid) and justify in 2–4 sentences. Solutions include the expected pick and reasoning.
2. **Fix this code** — A membership-in-list snippet causes jank; rewrite with the right structure in all four languages.

### Scenario prompts (attempt before opening solutions)

**S1.** Chat app: user scrolls up to load older messages; new messages can arrive at the bottom; must not show duplicates.

**S2.** Settings screen: undo the last five toggles the user flipped.

**S3.** Warehouse companion app: barcode scan must tell in &lt;16ms whether the SKU exists in a 40k-item catalog held on device.

**S4.** Social profile: show followers and decide whether “Follow” or “Following” for the viewed user; the following set is large.

**S5.** Image-heavy gallery: revisit recent thumbnails instantly, bound RAM, expire after 24 hours.

### Fix-this-code prompt

**Kotlin (Views)**

```kotlin
// CartActivity.bindRow — called for every visible row during scroll
fun bindRow(sku: String, cartSkus: List<String>, check: CheckBox) {
    check.isChecked = cartSkus.contains(sku) // ???
}
```

**Swift (UIKit)**

```swift
// CartViewController.configure — called for every visible cell during scroll
func configure(_ cell: UITableViewCell, sku: String, cartSkus: [String]) {
    cell.accessoryType = cartSkus.contains(sku) ? .checkmark : .none // ???
}
```

**Dart (Flutter)**

```dart
// Cart list itemBuilder — runs for every visible row during scroll
Widget buildRow(String sku, List<String> cartSkus) {
  return CheckboxListTile(
    title: Text(sku),
    value: cartSkus.contains(sku), // ???
    onChanged: (_) {},
  );
}
```

**TypeScript (React Native)**

```tsx
// FlatList renderItem — runs for every visible row during scroll
const renderRow = (sku: string, cartSkus: string[]) => (
  <Switch value={cartSkus.includes(sku)} /> // ???
);
```

The Jetpack Compose version of the same bug is `Checkbox(checked = cartSkus.contains(sku), …)` inside a `LazyColumn` item — it runs on every recomposition of every visible row.

Explain why this hurts, then provide a fixed version (and Swift/Dart/TS equivalents) in the solutions file.

---

## What to remember

Choose by **dominant operation**, not by habit. Lookup → hash; sequence → array; ends → stack/queue; hierarchy → tree; relations → graph; bounded reuse → cache; UI lists → array + stable IDs + diff. Hybrids are normal. The costliest mobile bugs are often “right idea, wrong structure on the UI thread.” Part V moves from structures to algorithmic thinking — searching, sorting, recursion — with the same frame-budget discipline.
