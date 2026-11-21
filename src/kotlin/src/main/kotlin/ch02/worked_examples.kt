// Worked examples (four languages)
// Source: book/part-i/02-big-o-notation.md
package ch02.worked_examples

fun frequencies(ids: List<String>): Map<String, Int> {
    val counts = HashMap<String, Int>()           // extra space O(u)
    for (id in ids) {                             // Θ(n)
        counts[id] = (counts[id] ?: 0) + 1        // O(1) average
    }
    return counts
}

// Θ(n²) — for each id, scan the whole list again
fun countNaive(ids: List<String>, target: String): Int {
    var c = 0
    for (i in ids.indices) {
        for (j in ids.indices) {                  // nested
            if (ids[j] == target) c++
        }
    }
    return c // also logically wrong/wasteful — illustration only
}
