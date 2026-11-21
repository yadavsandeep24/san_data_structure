// Worked example 1: merge busy blocks
// Source: book/part-iv/17-intervals-sweep-line.md
package ch17.worked_example_1_merge_busy_blocks

fun mergeBusy(blocks: List<IntArray>): List<IntArray> {
    if (blocks.isEmpty()) return emptyList()
    val sorted = blocks.sortedBy { it[0] }
    val out = mutableListOf(sorted[0].copyOf())
    for (i in 1 until sorted.size) {
        val cur = sorted[i]
        val last = out.last()
        if (cur[0] <= last[1]) {
            last[1] = maxOf(last[1], cur[1])   // overlap or touch: extend
        } else {
            out.add(cur.copyOf())              // gap: start a new block
        }
    }
    return out
}
