// Q10. Partition Labels (Chunking a Sync Log)
// Source: book/part-viii/35-heaps-tries-greedy.md
package ch35.q10_partition_labels

fun partitionLabels(s: String): List<Int> {
    val last = IntArray(26)
    for (i in s.indices) last[s[i] - 'a'] = i
    val sizes = mutableListOf<Int>()
    var start = 0
    var end = 0
    for (i in s.indices) {
        end = maxOf(end, last[s[i] - 'a'])
        if (i == end) {
            sizes += end - start + 1
            start = i + 1
        }
    }
    return sizes
}
