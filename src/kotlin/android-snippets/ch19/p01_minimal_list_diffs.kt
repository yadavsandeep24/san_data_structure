// P1: Minimal list diffs (insert / remove / update)
// Source: solutions/ch19/README.md
package ch19.p01_minimal_list_diffs

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
