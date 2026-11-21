// P3: Stable key generator
// Source: solutions/ch19/README.md
package ch19.p03_stable_key_generator

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
