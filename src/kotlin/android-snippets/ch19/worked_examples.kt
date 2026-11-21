// Worked examples (four languages)
// Source: book/part-v/19-efficient-list-rendering.md
package ch19.worked_examples

data class FeedItem(val id: String, val title: String)

fun keyOf(item: FeedItem) = item.id  // never position

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

fun appendPage(
    buffer: List<FeedItem>,
    seen: MutableSet<String>,
    page: List<FeedItem>,
): List<FeedItem> {
    val next = buffer.toMutableList()
    for (item in page) {
        if (!seen.add(item.id)) continue // add returns false if already present
        next += item
    }
    return next
}

data class FeedItem(val id: String, val title: String, val liked: Boolean)

class FeedViewModel : ViewModel() {
    private val _feed = MutableStateFlow<List<FeedItem>>(emptyList())
    val feed: StateFlow<List<FeedItem>> = _feed.asStateFlow()

    fun toggleLike(id: String) = _feed.update { list ->
        list.map { if (it.id == id) it.copy(liked = !it.liked) else it } // new list, same ids
    }
}

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
