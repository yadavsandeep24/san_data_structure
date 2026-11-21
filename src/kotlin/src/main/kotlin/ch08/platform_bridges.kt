// Platform bridges
// Source: book/part-iii/08-sets.md
package ch08.platform_bridges

class SelectionTracker {
    private val selected = LinkedHashSet<String>() // order = tap order

    fun toggle(id: String) {
        if (!selected.add(id)) selected.remove(id)
    }

    fun isSelected(id: String) = id in selected
    fun snapshot(): List<String> = selected.toList()
}
