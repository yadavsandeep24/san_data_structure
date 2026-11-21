// Prefix + hash map in code (Kotlin)
// Source: book/part-iv/15-prefix-sums.md
package ch15.prefix_hash_map_in_code

fun countSubarraysWithSum(a: IntArray, k: Int): Int {
    val seen = HashMap<Long, Int>().apply { put(0L, 1) }  // empty prefix
    var prefix = 0L
    var count = 0
    for (x in a) {
        prefix += x
        count += seen[prefix - k] ?: 0       // earlier prefixes that complete a sum-k run
        seen[prefix] = (seen[prefix] ?: 0) + 1
    }
    return count
}
