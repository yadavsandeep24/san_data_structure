// Worked example: nested loop vs HashSet membership
// Source: book/part-i/01-why-data-structures-matter.md
package ch01.worked_example_nested_loop_vs_hashset_membership

// BAD — O(n * m) if you do this for every row (n = rows, m = selected size)
fun isSelectedSlow(id: String, selected: List<String>): Boolean {
    for (s in selected) {          // O(m) per call
        if (s == id) return true
    }
    return false
}

// GOOD — build once O(m), then each lookup O(1) average
fun buildSelectedSet(selected: List<String>): Set<String> =
    selected.toHashSet()           // O(m)

fun isSelectedFast(id: String, selectedSet: Set<String>): Boolean =
    selectedSet.contains(id)       // O(1) average
