// P2: Paginated feed buffer
// Source: solutions/ch19/README.md
package ch19.p02_paginated_feed_buffer

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
