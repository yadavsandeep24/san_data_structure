# Chapter 13 — Efficient List Rendering

`notifyDataSetChanged()`. `reloadData()`. `setState` with a brand-new array reference and no keys. The list blinks, scroll position jumps, images flash, focus resets, and the main thread spends a frame rebuilding every cell you already had. The data structure underneath — an ordered array of row models — did not change much. The **diff** you fed the UI did.

This chapter is about treating list updates as structural problems: identity vs contents, minimal edit scripts, stable keys, and pagination buffers that append without duplicates.

---

## Mobile motivation

Scrollable lists are the hottest UI surface in most apps. Frameworks recycle views (RecyclerView, UITableView cells, Flutter slivers, RN recycling list comps). Recycling only helps when the adapter can say *which* rows changed. If you claim “everything changed,” the system tears down and rebuilds everything — animations die, and you pay O(visible) bind work plus often O(n) layout invalidation for no semantic reason.

| Symptom | Likely cause |
|---------|----------------|
| Flash of placeholders on every refresh | Full reload; image requests restarted |
| Scroll jump to top | List identity lost; component remount |
| Typing caret jumps in a row TextField | Wrong key / row reused with wrong identity |
| Frame spike on “like” of one item | Diff not computed; full rebind |
| Duplicate rows after “load more” | Pagination merge without an ID set |

---

## Why full invalidation is bad

| API / pattern | Platform | What it tells the UI |
|---------------|----------|----------------------|
| `notifyDataSetChanged()` | Android `RecyclerView` | Entire dataset may have changed — rebind broadly |
| `reloadData()` | iOS `UITableView` / `UICollectionView` | Tear down and reload all sections/rows |
| `ListView` without keys + new list | Flutter | Diff struggles; more rebuilds than needed |
| `FlatList` without stable `keyExtractor` | React Native | Reconciler remounts rows aggressively |

Full invalidation is acceptable for **tiny** lists or true full replacements (empty → first page). It is a foot-gun for feeds, search results, and chat.

**Prefer:** compute a minimal set of inserts, deletes, moves, and updates — then call granular APIs (`notifyItemInserted`, `performBatchUpdates`, `DiffUtil`, `ListView` keys, RN keys).

---

## Diffing: DiffUtil, collection difference, ListDiff, RN keys

### The idea

Given `oldList` and `newList` of items with stable IDs:

1. Decide **same item** by ID (identity).
2. Decide **same contents** by equality of display fields (or a payload hash).
3. Emit operations: insert, remove, move, change.

| Ecosystem | Tool |
|-----------|------|
| Android | `DiffUtil.Callback` + `AsyncListDiffer` / `ListAdapter` |
| iOS | `UITableViewDiffableDataSource` / `NSDiffableDataSourceSnapshot`; or `CollectionDifference` |
| Flutter | Prefer keyed widgets; packages like `great_list_view` / manual diffs; `ListView.builder` + `Key` |
| React Native | Reconciler uses `key`; `FlashList`/`FlatList` `keyExtractor`; avoid index keys |

### Identity vs contents

```text
identity  →  “is this the same row entity?”     (id: "msg_42")
contents  →  “did what we paint change?”       (text, liked, status)
```

- Identity stable, contents changed → **update** / rebind that row (ideally with payload).
- Identity gone → **remove**.
- New identity → **insert**.
- Same identities, different order → **move** (or remove+insert if your diff skips moves).

Using **index** as identity is the classic bug: insert at top shifts every index; rows morph into each other; TextFields show the wrong text.

### Cost note

Naive LCS-based diffs are O(n·m). Mobile list libs use Myers or heuristics with O(n) identity maps when IDs are unique. For interviews and practice, an O(n) ID-map approach that emits insert/remove/update (moves optional) is the right engineering default for feeds.

---

## Complexity at a glance

| Approach | Time | UI effect |
|----------|------|-----------|
| Full reload | O(n) bind worst | Worst UX |
| Diff with ID map | O(n + m) | Granular updates |
| Diff with LCS, no IDs | O(n·m) | Risky for large n on main thread |
| Async diff off main | O(n + m) background | Best for large lists (Android `AsyncListDiffer`) |

Run heavy diffs **off the main thread** when n is thousands; apply the result on the main thread in one batch.

---

## Pagination and lazy loading structures

A feed is not “one array forever.” It is a **growing buffer** plus a **page cursor**.

```text
[ page1 items ][ page2 items ][ page3 items ] ...
       ↑
   viewport (lazy bind / builder only builds visible)
```

| Structure | Role |
|-----------|------|
| `Array` / `List` of models | Order for the UI |
| `Set` of IDs | Dedupe on append |
| Cursor / page token | What to request next |
| Optional `Map<id, index>` | O(1) patch-by-id (likes, status) |

**Lazy loading UI** (RecyclerView, `ListView.builder`, `FlatList`) only constructs visible children. That does **not** free you from holding the whole model array in memory — it only skips building widgets. For huge histories, window the model (drop far-off pages) or use a paged source (Room Paging, etc.).

### Cursor vs offset pagination

| Style | Request looks like | Pros | Cons |
|-------|--------------------|------|------|
| **Offset** | `?offset=40&limit=20` | Simple math | Inserts above shift pages → duplicates/skips |
| **Cursor** | `?after=msg_980&limit=20` | Stable under inserts | Server must support opaque cursors |
| **Page number** | `?page=3` | Human-friendly | Same shift problems as offset |

**Mobile feeds should prefer cursors** (or time-based keys). Offset pagination breaks when new posts appear at the top while the user loads more at the bottom.

**Merge algorithm (append page):**

```text
for item in page:
  if item.id not in seen:
    seen.add(item.id)
    buffer.append(item)
nextCursor = page.nextCursor
```

**Prepend** (new items at top) is the same with `insert(0, …)` or better: build a new list and diff — repeated `insert(0)` is O(n²) on arrays (Chapter 3).

---

## Platform bridges

| Concern | Android | iOS | Flutter | React Native |
|---------|---------|-----|---------|--------------|
| Diff | `DiffUtil` / `ListAdapter`; Compose `LazyColumn` + `key` / `items(key=)` | Diffable data sources; SwiftUI `Identifiable` / `ForEach(id:)` | Keys + element rebuild | `key` / `keyExtractor` |
| Avoid | blanket `notifyDataSetChanged`; unstable Compose keys | blanket `reloadData`; identity from index in SwiftUI | index keys for stateful rows | `key={index}` |
| Pagination UI | Paging 3; Compose paging | diffable + manual cursor | `ListView.builder` + scroll listener | `onEndReached` |
| Patch one row | `notifyItemChanged(i, payload)`; immutable list + key | reconfigure item; `@Observable` / `Identifiable` update | immutable model + key (`setState`, Riverpod, or Bloc) | immutable update by id |

### Compose and SwiftUI identity (2020s defaults)

RecyclerView/`DiffUtil` and UIKit diffable sources still matter in many codebases, but new screens often use **Compose** and **SwiftUI**. **React Native 0.73+** defaults to the New Architecture (Fabric + JSI/TurboModules) — list identity (`keyExtractor`) and immutable data updates matter even when bridge overhead is lower. The DSA lesson is the same: **stable identity**, not position.

**Jetpack Compose** — `LazyColumn` recycles like RecyclerView. Pass a stable `key` so recomposition and scroll state stick to the right row when the list reorders:

```kotlin
LazyColumn {
    items(items = feed, key = { it.id }) { item ->
        FeedRow(item)
    }
}
```

Without `key`, Compose falls back to position — inserts at the top reshuffle identity the same way index keys do in RN/Flutter.

**SwiftUI** — Prefer `Identifiable` models (or explicit `id:`) in `ForEach` / `List`:

```swift
struct FeedItem: Identifiable {
    let id: String
    var title: String
}

List(feed) { item in
    Text(item.title)
}
```

Diffing then tracks `id`, not array index. Mutating `title` for the same `id` updates in place; changing `id` is treated as remove+insert.

---

## Worked examples (four languages)
### Stable keys from IDs

**Kotlin**

```kotlin
data class FeedItem(val id: String, val title: String)

fun keyOf(item: FeedItem) = item.id  // never position
```

**Swift**

```swift
struct FeedItem: Hashable {
    let id: String
    let title: String
}
// DiffableDataSource item identifier: item.id
```

**Dart**

```dart
class FeedItem {
  FeedItem({required this.id, required this.title});
  final String id;
  final String title;
}

// ListView.builder(itemBuilder: ..., findChildIndexCallback / Key)
Widget buildRow(FeedItem item) => ListTile(key: ValueKey(item.id), title: Text(item.title));
```

**TypeScript**

```typescript
type FeedItem = { id: string; title: string };

const keyExtractor = (item: FeedItem) => item.id; // FlatList
```

### Minimal ID-based diff (insert / remove / update)

Sketch: map old IDs → items; walk new list; collect removals for IDs not in new; updates when identity matches but contents differ.

```kotlin
sealed class ListEdit {
    data class Insert(val index: Int, val id: String) : ListEdit()
    data class Remove(val id: String) : ListEdit()
    data class Update(val id: String) : ListEdit()
}

data class Item(val id: String, val body: String)

fun diff(old: List<Item>, new: List<Item>): List<ListEdit> {
    val oldMap = old.associateBy { it.id }
    val newIds = new.map { it.id }.toHashSet()
    val edits = mutableListOf<ListEdit>()
    for (o in old) if (o.id !in newIds) edits += ListEdit.Remove(o.id)
    new.forEachIndexed { index, n ->
        val prev = oldMap[n.id]
        when {
            prev == null -> edits += ListEdit.Insert(index, n.id)
            prev.body != n.body -> edits += ListEdit.Update(n.id)
        }
    }
    return edits
}
```

Ports appear in the solutions for Practice 1.

### Append page without duplicates

```typescript
function appendPage(
  buffer: FeedItem[],
  seen: Set<string>,
  page: FeedItem[],
): FeedItem[] {
  const next = buffer.slice();
  for (const item of page) {
    if (seen.has(item.id)) continue;
    seen.add(item.id);
    next.push(item);
  }
  return next;
}
```

---

## Common mistakes

1. **`key={index}` / position identity** — inserts scramble row state.
2. **Full reload on every websocket event** — one message should patch one row.
3. **Diff on the main thread for 10k rows** — drop frames; use async differ.
4. **Offset pagination + prepend refresh** — silent duplicates; use cursors + ID set.
5. **Mutating the array in place** while the list is reading it — crash or blank cells; prefer immutable replace + diff.
6. **Storing bitmaps inside row models** — couple Chapter 12 caches; models hold URLs/IDs.
7. **Calling `notifyDataSetChanged` “just once for simplicity”** in a hot path — simplicity becomes permanent jank.

---

## Self-Check

Answers in Appendix D.

**13.1** Why does `reloadData` / `notifyDataSetChanged` restart image loads you already had on screen?

**13.2** What is the difference between identity and contents in a list diff?

**13.3** Why are index-based keys dangerous when rows contain text fields?

**13.4** Give one failure mode of offset pagination that cursor pagination avoids.

**13.5** Which two structures pair well for a paginated feed buffer, and what is each for?

---

## Practice Problems

Full model solutions:

→ **[`solutions/ch13/README.md`](../../solutions/ch13/README.md)**

1. **Minimal list diffs** — Given old/new arrays of `{id, value}`, emit insert/remove/update operations (by ID). Document complexity.
2. **Paginated feed buffer** — Implement a buffer that appends pages, skips duplicate IDs, and tracks `nextCursor`.
3. **Stable key generator** — From heterogeneous item types (`post`, `ad`, `header`), produce unique stable string keys; prove two different entities cannot collide.

---

## What to remember

Lists are ordered arrays plus identity. Teach the UI *what changed*, not that *everything might have*. Diff by ID, bind by contents, key by stable identity, merge pages with a set, prefer cursors over offsets. Next: a **decision guide** that pulls Parts II–IV together — which structure to reach for under time pressure.
