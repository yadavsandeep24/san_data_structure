// P3. Offline-First Feed
// Source: solutions/ch38/README.md
package ch38.p03_offline_first_feed

data class Entity(val id: String, val body: String)
data class Diff(val removals: List<String>, val inserts: List<Pair<Int, Entity>>, val updates: List<Entity>)

class FeedBuffer {
    private val items = mutableListOf<Entity>()
    private val index = HashMap<String, Int>()

    fun applyPage(page: List<Entity>, prepend: Boolean) {
        val fresh = page.filter { it.id !in index }
        if (prepend) {
            items.addAll(0, fresh)
        } else {
            items.addAll(fresh)
        }
        reindex()
    }
    private fun reindex() {
        index.clear()
        items.forEachIndexed { i, e -> index[e.id] = i }
    }
    fun snapshot(): List<Entity> = items.toList()

    fun diff(old: List<Entity>, new: List<Entity>): Diff {
        val oldIds = old.map { it.id }.toSet()
        val newMap = new.associateBy { it.id }
        val removals = old.map { it.id }.filter { it !in newMap }
        val inserts = new.withIndex().filter { it.value.id !in oldIds }.map { it.index to it.value }
        val updates = new.filter { it.id in oldIds && old[old.indexOfFirst { o -> o.id == it.id }].body != it.body }
        return Diff(removals, inserts, updates)
    }
}

class FeedViewModel(private val buffer: FeedBuffer = FeedBuffer()) : ViewModel() {
    private val _items = MutableStateFlow<List<Entity>>(emptyList())
    val items: StateFlow<List<Entity>> = _items.asStateFlow()

    fun onPage(page: List<Entity>, prepend: Boolean) {
        buffer.applyPage(page, prepend)
        _items.value = buffer.snapshot() // new immutable list every time
    }
}

// Views: ListAdapter<Entity, VH>(EntityDiff), where EntityDiff compares ids / then contents
object EntityDiff : DiffUtil.ItemCallback<Entity>() {
    override fun areItemsTheSame(old: Entity, new: Entity) = old.id == new.id
    override fun areContentsTheSame(old: Entity, new: Entity) = old == new
}
// in the Fragment, inside repeatOnLifecycle(STARTED):
//     viewModel.items.collect { adapter.submitList(it) }

// Compose
@Composable
fun FeedList(viewModel: FeedViewModel, listState: LazyListState) {
    val items by viewModel.items.collectAsStateWithLifecycle()
    LazyColumn(state = listState) {
        items(items, key = { it.id }) { EntityRow(it) }
    }
}
