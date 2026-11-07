# Chapter 13 — Model Solutions

## P1: Minimal list diffs (insert / remove / update)

### Approach

Index the old list by `id`. Build the set of new IDs. Every old ID missing from new → `Remove`. Every new item: if ID absent in old → `Insert(index)`; else if `value` differs → `Update`. (Moves omitted; order of new list is the target order when applying inserts carefully in interviews — here we report structural edits for teaching.)

### Complexity

- Time: O(n + m)
- Space: O(n + m) for maps/sets

### Edge cases

- Empty old → all inserts
- Empty new → all removes
- Duplicate IDs — undefined; assume unique IDs
- Same ID, same value → no-op

### Mobile note

This is the mental model behind `DiffUtil.areItemsTheSame` (ID) vs `areContentsTheSame` (value) in the View system, and behind `LazyColumn` `key` (ID) plus recomposition skipping (value) in Jetpack Compose. Prefer the framework on device; know this algorithm in interviews.

### Kotlin

```kotlin
data class Row(val id: String, val value: String)

sealed class Edit {
    data class Insert(val index: Int, val id: String) : Edit()
    data class Remove(val id: String) : Edit()
    data class Update(val id: String) : Edit()
}

fun minimalDiff(old: List<Row>, new: List<Row>): List<Edit> {
    val oldMap = old.associateBy { it.id }
    val newIds = new.mapTo(HashSet()) { it.id }
    val edits = ArrayList<Edit>()
    for (o in old) {
        if (o.id !in newIds) edits += Edit.Remove(o.id)
    }
    new.forEachIndexed { index, n ->
        val prev = oldMap[n.id]
        when {
            prev == null -> edits += Edit.Insert(index, n.id)
            prev.value != n.value -> edits += Edit.Update(n.id)
        }
    }
    return edits
}
```

### Kotlin — the same split inside both Android toolkits

```kotlin
// Views: ListAdapter runs this diff off the main thread and emits notifyItem* calls
object RowDiff : DiffUtil.ItemCallback<Row>() {
    override fun areItemsTheSame(old: Row, new: Row) = old.id == new.id           // Remove/Insert vs keep
    override fun areContentsTheSame(old: Row, new: Row) = old.value == new.value  // Update vs no-op
}

// Compose: no edit script — identity comes from key, contents from skipping equal rows
@Composable
fun Rows(rows: List<Row>) {
    LazyColumn {
        items(rows, key = { it.id }) { row -> Text(row.value) }
    }
}
```

### Swift

```swift
struct Row: Equatable {
    let id: String
    let value: String
}

enum Edit: Equatable {
    case insert(index: Int, id: String)
    case remove(id: String)
    case update(id: String)
}

func minimalDiff(old: [Row], new: [Row]) -> [Edit] {
    let oldMap = Dictionary(uniqueKeysWithValues: old.map { ($0.id, $0) })
    let newIds = Set(new.map(\.id))
    var edits: [Edit] = []
    for o in old where !newIds.contains(o.id) {
        edits.append(.remove(id: o.id))
    }
    for (index, n) in new.enumerated() {
        if let prev = oldMap[n.id] {
            if prev.value != n.value { edits.append(.update(id: n.id)) }
        } else {
            edits.append(.insert(index: index, id: n.id))
        }
    }
    return edits
}
```

### Dart

```dart
class Row {
  Row(this.id, this.value);
  final String id;
  final String value;
}

sealed class Edit {}
class Insert extends Edit {
  Insert(this.index, this.id);
  final int index;
  final String id;
}
class Remove extends Edit {
  Remove(this.id);
  final String id;
}
class Update extends Edit {
  Update(this.id);
  final String id;
}

List<Edit> minimalDiff(List<Row> old, List<Row> neu) {
  final oldMap = {for (final o in old) o.id: o};
  final newIds = neu.map((e) => e.id).toSet();
  final edits = <Edit>[];
  for (final o in old) {
    if (!newIds.contains(o.id)) edits.add(Remove(o.id));
  }
  for (var i = 0; i < neu.length; i++) {
    final n = neu[i];
    final prev = oldMap[n.id];
    if (prev == null) {
      edits.add(Insert(i, n.id));
    } else if (prev.value != n.value) {
      edits.add(Update(n.id));
    }
  }
  return edits;
}
```

### TypeScript

```typescript
type Row = { id: string; value: string };
type Edit =
  | { type: "insert"; index: number; id: string }
  | { type: "remove"; id: string }
  | { type: "update"; id: string };

function minimalDiff(old: Row[], neu: Row[]): Edit[] {
  const oldMap = new Map(old.map((r) => [r.id, r]));
  const newIds = new Set(neu.map((r) => r.id));
  const edits: Edit[] = [];
  for (const o of old) {
    if (!newIds.has(o.id)) edits.push({ type: "remove", id: o.id });
  }
  neu.forEach((n, index) => {
    const prev = oldMap.get(n.id);
    if (!prev) edits.push({ type: "insert", index, id: n.id });
    else if (prev.value !== n.value) edits.push({ type: "update", id: n.id });
  });
  return edits;
}
```

---

## P2: Paginated feed buffer

### Approach

Keep `items: List`, `seen: Set<id>`, and `nextCursor`. `append(page, cursor)` adds only unseen IDs; updates cursor. Optionally `reset()` for pull-to-refresh.

### Complexity

- Append page of size p: O(p) average
- Space: O(n) for items + set

### Edge cases

- Empty page — still update cursor if server says so
- Full-page duplicates — buffer unchanged, cursor advances
- Interleaved refresh — call `reset` then append first page

### Mobile note

Prefer cursor tokens from the server. Pair with `DiffUtil`/`ListAdapter` (Views), `LazyColumn` `key` (Compose), or `keyExtractor` (RN) when replacing the UI list reference. On Android, Paging 3 (`PagingDataAdapter` / `collectAsLazyPagingItems`) packages this buffer for you — Chapter 13.

### Kotlin

```kotlin
data class FeedItem(val id: String, val body: String)
data class Page(val items: List<FeedItem>, val nextCursor: String?)

class FeedBuffer {
    private val items = mutableListOf<FeedItem>()
    private val seen = HashSet<String>()
    var nextCursor: String? = null
        private set

    fun snapshot(): List<FeedItem> = items.toList()

    fun append(page: Page) {
        for (item in page.items) {
            if (seen.add(item.id)) items.add(item)
        }
        nextCursor = page.nextCursor
    }

    fun reset() {
        items.clear()
        seen.clear()
        nextCursor = null
    }

    fun hasMore(): Boolean = nextCursor != null
}
```

### Kotlin — "load more" trigger in both Android toolkits

Both call the same `onLoadMore()`, which must be idempotent (ignore calls while a page is in flight) because scroll events fire many times.

```kotlin
// Views
fun RecyclerView.onNearEnd(threshold: Int = 5, onLoadMore: () -> Unit) {
    addOnScrollListener(object : RecyclerView.OnScrollListener() {
        override fun onScrolled(rv: RecyclerView, dx: Int, dy: Int) {
            val lm = rv.layoutManager as LinearLayoutManager
            if (dy > 0 && lm.findLastVisibleItemPosition() >= lm.itemCount - threshold) onLoadMore()
        }
    })
}

// Compose
@Composable
fun LoadMoreEffect(listState: LazyListState, threshold: Int = 5, onLoadMore: () -> Unit) {
    val nearEnd by remember {
        derivedStateOf {
            val last = listState.layoutInfo.visibleItemsInfo.lastOrNull()?.index ?: 0
            last >= listState.layoutInfo.totalItemsCount - threshold
        }
    }
    LaunchedEffect(nearEnd) { if (nearEnd) onLoadMore() }
}
```

### Swift

```swift
struct FeedItem: Hashable {
    let id: String
    let body: String
}

struct Page {
    let items: [FeedItem]
    let nextCursor: String?
}

final class FeedBuffer {
    private(set) var items: [FeedItem] = []
    private var seen: Set<String> = []
    private(set) var nextCursor: String?

    func append(_ page: Page) {
        for item in page.items where seen.insert(item.id).inserted {
            items.append(item)
        }
        nextCursor = page.nextCursor
    }

    func reset() {
        items.removeAll()
        seen.removeAll()
        nextCursor = nil
    }

    var hasMore: Bool { nextCursor != nil }
}
```

### Dart

```dart
class FeedItem {
  FeedItem(this.id, this.body);
  final String id;
  final String body;
}

class Page {
  Page(this.items, this.nextCursor);
  final List<FeedItem> items;
  final String? nextCursor;
}

class FeedBuffer {
  final _items = <FeedItem>[];
  final _seen = <String>{};
  String? nextCursor;

  List<FeedItem> get items => List.unmodifiable(_items);
  bool get hasMore => nextCursor != null;

  void append(Page page) {
    for (final item in page.items) {
      if (_seen.add(item.id)) _items.add(item);
    }
    nextCursor = page.nextCursor;
  }

  void reset() {
    _items.clear();
    _seen.clear();
    nextCursor = null;
  }
}
```

### TypeScript

```typescript
type FeedItem = { id: string; body: string };
type Page = { items: FeedItem[]; nextCursor: string | null };

class FeedBuffer {
  private items: FeedItem[] = [];
  private seen = new Set<string>();
  nextCursor: string | null = null;

  snapshot(): FeedItem[] {
    return this.items.slice();
  }

  append(page: Page): void {
    for (const item of page.items) {
      if (this.seen.has(item.id)) continue;
      this.seen.add(item.id);
      this.items.push(item);
    }
    this.nextCursor = page.nextCursor;
  }

  reset(): void {
    this.items = [];
    this.seen.clear();
    this.nextCursor = null;
  }

  hasMore(): boolean {
    return this.nextCursor != null;
  }
}
```

---

## P3: Stable key generator

### Approach

Namespace keys by type prefix so a post with id `"1"` and an ad with id `"1"` cannot collide: `post:1` vs `ad:1`. Headers use their section id. Reject blank IDs.

### Complexity

- O(1) per key / O(length of id) string concat
- Space: O(1) extra

### Edge cases

- Empty id — throw / assert
- Unknown type — exhaustive when / default error
- Do not use list index

### Mobile note

Use as `keyExtractor`, `ValueKey`, diffable item identifier, `DiffUtil` identity (Android Views), or `LazyColumn` `key` (Jetpack Compose — where a duplicate key throws at runtime). Prefixing is the standard fix for heterogeneous lists (stories + ads + markers).

### Kotlin

```kotlin
sealed class FeedEntry {
    data class Post(val id: String) : FeedEntry()
    data class Ad(val id: String) : FeedEntry()
    data class Header(val sectionId: String) : FeedEntry()
}

fun stableKey(entry: FeedEntry): String = when (entry) {
    is FeedEntry.Post -> {
        require(entry.id.isNotBlank()); "post:${entry.id}"
    }
    is FeedEntry.Ad -> {
        require(entry.id.isNotBlank()); "ad:${entry.id}"
    }
    is FeedEntry.Header -> {
        require(entry.sectionId.isNotBlank()); "header:${entry.sectionId}"
    }
}

// Collision proof sketch: Post("1") → "post:1"; Ad("1") → "ad:1" — unequal strings
```

### Kotlin — wiring the key into Views and Compose

```kotlin
// Views: identity in DiffUtil; the entry class picks the view type
object EntryDiff : DiffUtil.ItemCallback<FeedEntry>() {
    override fun areItemsTheSame(old: FeedEntry, new: FeedEntry) = stableKey(old) == stableKey(new)
    override fun areContentsTheSame(old: FeedEntry, new: FeedEntry) = old == new
}

fun viewTypeOf(entry: FeedEntry): Int = when (entry) {   // return from ListAdapter.getItemViewType
    is FeedEntry.Post -> 0
    is FeedEntry.Ad -> 1
    is FeedEntry.Header -> 2
}

// Compose: the same key; contentType mirrors getItemViewType
@Composable
fun Entries(entries: List<FeedEntry>) {
    LazyColumn {
        items(entries, key = ::stableKey, contentType = { it::class }) { entry -> EntryRow(entry) }
    }
}
```

### Swift

```swift
enum FeedEntry {
    case post(id: String)
    case ad(id: String)
    case header(sectionId: String)
}

func stableKey(_ entry: FeedEntry) -> String {
    switch entry {
    case .post(let id):
        precondition(!id.isEmpty); return "post:\(id)"
    case .ad(let id):
        precondition(!id.isEmpty); return "ad:\(id)"
    case .header(let sectionId):
        precondition(!sectionId.isEmpty); return "header:\(sectionId)"
    }
}
```

### Dart

```dart
sealed class FeedEntry {}
class Post extends FeedEntry {
  Post(this.id);
  final String id;
}
class Ad extends FeedEntry {
  Ad(this.id);
  final String id;
}
class Header extends FeedEntry {
  Header(this.sectionId);
  final String sectionId;
}

String stableKey(FeedEntry entry) {
  switch (entry) {
    case Post(:final id):
      assert(id.isNotEmpty);
      return 'post:$id';
    case Ad(:final id):
      assert(id.isNotEmpty);
      return 'ad:$id';
    case Header(:final sectionId):
      assert(sectionId.isNotEmpty);
      return 'header:$sectionId';
  }
}
```

### TypeScript

```typescript
type FeedEntry =
  | { type: "post"; id: string }
  | { type: "ad"; id: string }
  | { type: "header"; sectionId: string };

function stableKey(entry: FeedEntry): string {
  switch (entry.type) {
    case "post":
      if (!entry.id) throw new Error("blank id");
      return `post:${entry.id}`;
    case "ad":
      if (!entry.id) throw new Error("blank id");
      return `ad:${entry.id}`;
    case "header":
      if (!entry.sectionId) throw new Error("blank id");
      return `header:${entry.sectionId}`;
  }
}

// FlatList: keyExtractor={(item) => stableKey(item)}
```
