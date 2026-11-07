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

## Android: RecyclerView (Views) vs LazyColumn (Compose)

Most Android codebases you will join have **both**: older screens on XML layouts + `RecyclerView`, newer ones on Compose, and seams where one hosts the other. Interviewers ask about both. The data structure underneath is identical — an ordered `List<FeedItem>` with stable IDs, produced by the same ViewModel. Only the renderer differs, and each renderer needs the same two answers from you: **which row is this (identity)** and **did what we paint change (contents)**.

### Concept map

| Question the list asks | Views: `RecyclerView` + `ListAdapter` | Compose: `LazyColumn` / `LazyRow` |
|------------------------|----------------------------------------|-----------------------------------|
| Same entity? (identity) | `DiffUtil.ItemCallback.areItemsTheSame` — compare `id` | `items(items, key = { it.id })` |
| Same pixels? (contents) | `areContentsTheSame` — usually data-class `==` | Recomposition **skipping**: a row whose parameters are stable and `equals` the previous ones is not re-run |
| What exactly changed? (partial bind) | `getChangePayload` → `onBindViewHolder(holder, position, payloads)` updates one view | Implicit: only composables that **read** the changed value recompose; split rows into small composables so a like toggles the icon, not the whole row |
| Which reuse bucket? | `getItemViewType` | `contentType = { … }` |
| Where does the diff run? | `ListAdapter` / `AsyncListDiffer` run DiffUtil on a background executor, then dispatch granular `notifyItem*` on main | No diff step — the lazy list matches keys on the main thread during composition; keep filtering/sorting in the ViewModel or in `remember(inputs) { … }` |
| Stable identity without DiffUtil | `setHasStableIds(true)` + `getItemId()` (needs a unique `Long`; hashing a `String` id can collide) | `key` already is the stable id |
| Container size never changes with content | `setHasFixedSize(true)` — skips a full `requestLayout` on item changes | N/A — the lazy layout is measured by its constraints, not its items |
| Nested horizontal lists | Share one `RecyclerView.RecycledViewPool` across inner lists; `LinearLayoutManager.initialPrefetchItemCount` | `LazyRow` inside a `LazyColumn` item, with its own `key`/`contentType`; no public cross-list pool — reuse happens inside each lazy list |
| Paging 3 | `PagingDataAdapter` + `submitData(pagingData)` | `collectAsLazyPagingItems()` + `itemKey { }` / `itemContentType { }` |
| Anti-pattern | `notifyDataSetChanged()`, mutating the list you passed to `submitList` | No `key` (position identity), mutable/unstable row models, heavy work in the composable body |

`ListAdapter.submitList` compares **list instances** first: submitting the same mutated `MutableList` again is a no-op. Always emit a new list (`copy`, `map`) — the same immutable-update discipline Compose's `StateFlow`/snapshot state requires.

### Stable, immutable row models (Compose)

Compose decides "can I skip this row?" from parameter **stability**. A `data class` with only `val` properties of stable types (`String`, `Int`, `Boolean`, other stable classes) is inferred stable — `FeedItem(id, title, liked)` needs nothing extra. Add `@Immutable` only when the compiler cannot prove it (model from a module not compiled with the Compose compiler, or a `List<…>` field), or switch such fields to `kotlinx.collections.immutable.ImmutableList`. With strong skipping (default in recent Compose compilers), unstable parameters are compared by **instance** (`===`), so a fresh-but-equal `List` still recomposes. Either way, mutating a model in place is invisible to both toolkits: Compose sees no state change, and DiffUtil compares an object to itself.

### `remember` and `derivedStateOf` — keep per-frame work out of the list

| Need | Views | Compose |
|------|-------|---------|
| Filter/sort once per input change | In the ViewModel, then `submitList` | In the ViewModel, or `remember(feed, query) { feed.filter { … } }` |
| React to scroll without per-pixel work | `RecyclerView.OnScrollListener` + compare against last value | `remember { derivedStateOf { listState.firstVisibleItemIndex > 5 } }` — downstream recomposes only when the boolean flips |
| Per-row membership ("is selected?") | Adapter holds a `Set<String>`; payload on toggle | Pass `id in selectedIds` (a `Set`) into the row |

### Pagination: Paging 3 in both toolkits

The `Pager` / `PagingSource` / `cachedIn(viewModelScope)` half lives in the ViewModel and is **shared**. The cursor discipline from earlier in this chapter applies unchanged: `PagingSource<String, FeedItem>` keyed by the server cursor, `nextKey = page.nextCursor`. Paging 3 does **not** dedupe by ID across pages for you — and a duplicate `key` in a `LazyColumn` throws at runtime, while duplicates under DiffUtil give undefined animations. Dedupe server-side (cursors) or before items reach the UI.

| Step | Views | Compose |
|------|-------|---------|
| Adapter / state | `class FeedPagingAdapter : PagingDataAdapter<FeedItem, RowHolder>(FeedDiff)` — same `ItemCallback` as `ListAdapter` | `val items = viewModel.pagedFeed.collectAsLazyPagingItems()` |
| Feed it | `viewModel.pagedFeed.collectLatest { adapter.submitData(it) }` inside `repeatOnLifecycle` | Automatic — `LazyPagingItems` collects for you |
| Read a row | `getItem(position)` returns `FeedItem?` (null = placeholder) | `items[index]` returns `FeedItem?` and also triggers the next page load |
| Keys | DiffUtil identity | `items(count = items.itemCount, key = items.itemKey { it.id }, contentType = items.itemContentType { "post" })` |
| Footer spinner / retry | `adapter.withLoadStateFooter(LoadStateAdapter)`; `adapter.retry()` | `when (items.loadState.append)` in a trailing `item { }`; `items.retry()` |

### Mixing the two toolkits

| Direction | API | Note |
|-----------|-----|------|
| Compose row inside a `RecyclerView` | `ComposeView` as the ViewHolder's `itemView`; `setContent { FeedRow(item) }` in bind | Default `ViewCompositionStrategy.DisposeOnDetachedFromWindowOrReleasedFromPool` keeps the composition while the holder sits in the pool (RecyclerView 1.3+), so recycled holders do not rebuild from scratch |
| Legacy `View` inside a `LazyColumn` | `AndroidView(factory, update, onReset = { … })` | A non-null `onReset` lets the lazy list reuse the View instead of discarding it on scroll |
| Whole screen migration | Fragment hosting `ComposeView` with `setContent { FeedScreen(viewModel) }` | Same ViewModel, same `StateFlow<List<FeedItem>>`; only the renderer changes |

The Kotlin for all of this is in **Worked examples** below.

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

### Android, both toolkits: one ViewModel, two renderers

The model gains a `liked` flag so a like can be a partial update. The ViewModel is shared; everything below it is toolkit-specific.

**Kotlin — shared model + ViewModel**

```kotlin
data class FeedItem(val id: String, val title: String, val liked: Boolean)

class FeedViewModel : ViewModel() {
    private val _feed = MutableStateFlow<List<FeedItem>>(emptyList())
    val feed: StateFlow<List<FeedItem>> = _feed.asStateFlow()

    fun toggleLike(id: String) = _feed.update { list ->
        list.map { if (it.id == id) it.copy(liked = !it.liked) else it } // new list, same ids
    }
}
```

**Kotlin — Views: XML row + `ListAdapter` + `DiffUtil.ItemCallback` with payloads**

```xml
<!-- res/layout/item_feed.xml -->
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:orientation="horizontal"
    android:padding="16dp">

    <TextView
        android:id="@+id/title"
        android:layout_width="0dp"
        android:layout_height="wrap_content"
        android:layout_weight="1" />

    <ImageButton
        android:id="@+id/like"
        android:layout_width="48dp"
        android:layout_height="48dp"
        android:contentDescription="Like" />
</LinearLayout>
```

```kotlin
data class LikeChanged(val liked: Boolean)

object FeedDiff : DiffUtil.ItemCallback<FeedItem>() {
    override fun areItemsTheSame(old: FeedItem, new: FeedItem) = old.id == new.id   // identity
    override fun areContentsTheSame(old: FeedItem, new: FeedItem) = old == new      // contents
    override fun getChangePayload(old: FeedItem, new: FeedItem): Any? =
        if (old.copy(liked = new.liked) == new) LikeChanged(new.liked) else null    // only `liked` moved
}

class FeedAdapter(
    private val onLike: (id: String) -> Unit,
) : ListAdapter<FeedItem, FeedAdapter.RowHolder>(FeedDiff) {

    class RowHolder(val binding: ItemFeedBinding) : RecyclerView.ViewHolder(binding.root)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RowHolder =
        RowHolder(ItemFeedBinding.inflate(LayoutInflater.from(parent.context), parent, false))

    override fun onBindViewHolder(holder: RowHolder, position: Int) {
        val item = getItem(position)
        holder.binding.title.text = item.title
        holder.binding.like.isSelected = item.liked
        holder.binding.like.setOnClickListener { onLike(item.id) }
    }

    // Partial bind: a like toggles one icon; title and image are not touched.
    override fun onBindViewHolder(holder: RowHolder, position: Int, payloads: List<Any>) {
        val like = payloads.filterIsInstance<LikeChanged>().lastOrNull()
        if (like == null) onBindViewHolder(holder, position)
        else holder.binding.like.isSelected = like.liked
    }
}

class FeedFragment : Fragment(R.layout.fragment_feed) {
    private val viewModel: FeedViewModel by viewModels()

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        val adapter = FeedAdapter(onLike = viewModel::toggleLike)
        view.findViewById<RecyclerView>(R.id.feed).apply {
            layoutManager = LinearLayoutManager(context)
            this.adapter = adapter
            setHasFixedSize(true) // item changes never resize the RecyclerView itself
        }
        viewLifecycleOwner.lifecycleScope.launch {
            viewLifecycleOwner.repeatOnLifecycle(Lifecycle.State.STARTED) {
                viewModel.feed.collect { adapter.submitList(it) } // DiffUtil runs off the main thread
            }
        }
    }
}
```

Nested carousels (a vertical feed of horizontal rows) share one pool so a card scrolled out of row 3 can be reused by row 7:

```kotlin
const val VIEW_TYPE_CARD = 1
val sharedCardPool = RecyclerView.RecycledViewPool().apply {
    setMaxRecycledViews(VIEW_TYPE_CARD, 20)
}

fun setUpCarousel(inner: RecyclerView) {
    inner.setRecycledViewPool(sharedCardPool)
    inner.layoutManager = LinearLayoutManager(inner.context, RecyclerView.HORIZONTAL, false).apply {
        initialPrefetchItemCount = 4 // cards visible when the row scrolls in
    }
}
```

**Kotlin — Compose: `LazyColumn` with `key`, `contentType`, `derivedStateOf`**

```kotlin
@Composable
fun FeedScreen(viewModel: FeedViewModel) {
    val feed by viewModel.feed.collectAsStateWithLifecycle()
    val listState = rememberLazyListState()
    // Recomputed only when the *boolean* flips, not on every scroll pixel.
    val showJumpToTop by remember { derivedStateOf { listState.firstVisibleItemIndex > 5 } }
    val scope = rememberCoroutineScope()

    Box {
        LazyColumn(state = listState) {
            items(
                items = feed,
                key = { it.id },             // identity (areItemsTheSame)
                contentType = { "post" },    // reuse bucket (getItemViewType)
            ) { item ->
                FeedRow(item, onLike = viewModel::toggleLike)
            }
        }
        if (showJumpToTop) JumpToTopButton(onClick = { scope.launch { listState.scrollToItem(0) } })
    }
}

@Composable
fun FeedRow(item: FeedItem, onLike: (String) -> Unit) {
    // FeedItem is all-val with stable field types → inferred stable; skipped when equal.
    Row {
        Text(item.title, Modifier.weight(1f))
        LikeIcon(liked = item.liked, onClick = { onLike(item.id) })
    }
}

@Composable
fun FilteredFeed(feed: List<FeedItem>, query: String) {
    val visible = remember(feed, query) { feed.filter { query in it.title } } // not per recomposition
    LazyColumn {
        items(visible, key = { it.id }) { Text(it.title) }
    }
}
```

Heterogeneous feeds (Practice 3) combine namespaced keys with a per-type `contentType`, the Compose twin of `getItemViewType`:

```kotlin
sealed interface FeedEntry {
    val id: String
    data class Post(override val id: String, val item: FeedItem) : FeedEntry
    data class Ad(override val id: String) : FeedEntry
    data class Header(override val id: String) : FeedEntry
}

@Composable
fun MixedFeed(entries: List<FeedEntry>, onLike: (String) -> Unit) {
    LazyColumn {
        items(
            items = entries,
            key = { e ->
                when (e) {
                    is FeedEntry.Post -> "post:${e.id}"
                    is FeedEntry.Ad -> "ad:${e.id}"
                    is FeedEntry.Header -> "header:${e.id}"
                }
            },
            contentType = { e -> e::class },
        ) { e ->
            when (e) {
                is FeedEntry.Post -> FeedRow(e.item, onLike)
                is FeedEntry.Ad -> AdRow(e)
                is FeedEntry.Header -> SectionHeader(e)
            }
        }
    }
}
```

**Kotlin — mixing: Compose row in a `RecyclerView`, `View` in a `LazyColumn`**

```kotlin
class ComposeRowHolder(private val composeView: ComposeView) : RecyclerView.ViewHolder(composeView) {
    fun bind(item: FeedItem, onLike: (String) -> Unit) {
        composeView.setContent { FeedRow(item, onLike) }
    }
}

@Composable
fun LegacyRow(item: FeedItem) {
    AndroidView(
        factory = { ctx -> TextView(ctx) },
        update = { view -> view.text = item.title },
        onReset = { view -> view.text = null }, // non-null → reusable inside lazy lists
    )
}
```

**Kotlin — Paging 3: shared source, two adapters**

```kotlin
class FeedPagingSource(private val api: FeedApi) : PagingSource<String, FeedItem>() {
    override suspend fun load(params: LoadParams<String>): LoadResult<String, FeedItem> = try {
        val page = api.feed(after = params.key, limit = params.loadSize) // cursor, not offset
        LoadResult.Page(data = page.items, prevKey = null, nextKey = page.nextCursor)
    } catch (e: IOException) {
        LoadResult.Error(e)
    }

    override fun getRefreshKey(state: PagingState<String, FeedItem>): String? = null // refresh from the top
}

class PagedFeedViewModel(api: FeedApi) : ViewModel() {
    val pagedFeed: Flow<PagingData<FeedItem>> =
        Pager(PagingConfig(pageSize = 20)) { FeedPagingSource(api) }
            .flow
            .cachedIn(viewModelScope) // survives rotation; both toolkits collect this
}
```

```kotlin
// Views — same FeedDiff as ListAdapter
class FeedPagingAdapter : PagingDataAdapter<FeedItem, FeedAdapter.RowHolder>(FeedDiff) {
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int) =
        FeedAdapter.RowHolder(ItemFeedBinding.inflate(LayoutInflater.from(parent.context), parent, false))

    override fun onBindViewHolder(holder: FeedAdapter.RowHolder, position: Int) {
        val item = getItem(position)             // null = placeholder not loaded yet
        holder.binding.title.text = item?.title.orEmpty()
    }
}
// in onViewCreated, inside repeatOnLifecycle(STARTED):
//     viewModel.pagedFeed.collectLatest { pagingAdapter.submitData(it) }

// Compose
@Composable
fun PagedFeed(viewModel: PagedFeedViewModel, onLike: (String) -> Unit) {
    val items = viewModel.pagedFeed.collectAsLazyPagingItems()
    LazyColumn {
        items(
            count = items.itemCount,
            key = items.itemKey { it.id },
            contentType = items.itemContentType { "post" },
        ) { index ->
            val item = items[index]                  // also triggers loading the next page
            if (item == null) PlaceholderRow() else FeedRow(item, onLike)
        }
    }
}
```

`FeedApi`, `JumpToTopButton`, `LikeIcon`, `AdRow`, `SectionHeader`, and `PlaceholderRow` are app-specific stand-ins.

---

## Common mistakes

1. **`key={index}` / position identity** — inserts scramble row state.
2. **Full reload on every websocket event** — one message should patch one row.
3. **Diff on the main thread for 10k rows** — drop frames; use async differ.
4. **Offset pagination + prepend refresh** — silent duplicates; use cursors + ID set.
5. **Mutating the array in place** while the list is reading it — crash or blank cells; prefer immutable replace + diff.
6. **Storing bitmaps inside row models** — couple Chapter 12 caches; models hold URLs/IDs.
7. **Calling `notifyDataSetChanged` “just once for simplicity”** in a hot path — simplicity becomes permanent jank.
8. **Duplicate keys** — `LazyColumn` throws on a repeated `key`; `DiffUtil` with repeated IDs animates unpredictably. The dedupe `Set` is not optional in either toolkit.
9. **Re-submitting a mutated list** — `ListAdapter.submitList(sameList)` is ignored, and Compose never sees an in-place mutation. Emit a new list.
10. **Per-frame work in the row** — sorting/filtering in `onBindViewHolder` or in a composable body without `remember(inputs)`; scroll-driven logic without `derivedStateOf`.

---

## Self-Check

Answers in Appendix D.

**13.1** Why does `reloadData` / `notifyDataSetChanged` restart image loads you already had on screen?

**13.2** What is the difference between identity and contents in a list diff?

**13.3** Why are index-based keys dangerous when rows contain text fields?

**13.4** Give one failure mode of offset pagination that cursor pagination avoids.

**13.5** Which two structures pair well for a paginated feed buffer, and what is each for?

**13.6** Map `areItemsTheSame`, `areContentsTheSame`, and `getChangePayload` onto their Jetpack Compose `LazyColumn` equivalents.

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
