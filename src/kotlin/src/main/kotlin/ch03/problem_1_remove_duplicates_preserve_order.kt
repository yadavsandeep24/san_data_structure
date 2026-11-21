// Problem 1 — Remove duplicates, preserve order
// Source: solutions/ch03/README.md
package ch03.problem_1_remove_duplicates_preserve_order

fun removeDuplicatesPreserveOrder(ids: List<String>): List<String> {
    val seen = HashSet<String>()                 // O(u) space
    val out = ArrayList<String>()
    for (id in ids) {                            // Θ(n)
        if (seen.add(id)) {                      // O(1) average; true if new
            out.add(id)                          // O(1) amortized
        }
    }
    return out
}

// Example
// removeDuplicatesPreserveOrder(listOf("a", "b", "a", "c", "b")) == ["a", "b", "c"]
