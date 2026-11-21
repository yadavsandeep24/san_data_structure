// Q4. Top K Frequent Elements
// Source: book/part-viii/29-interview-questions-q01-q10.md
package ch29.q04_top_k_frequent_elements

fun topKFrequent(nums: IntArray, k: Int): IntArray {
    val freq = HashMap<Int, Int>()
    for (x in nums) freq[x] = (freq[x] ?: 0) + 1
    val buckets = Array(nums.size + 1) { mutableListOf<Int>() }
    for ((v, f) in freq) buckets[f].add(v)
    val out = mutableListOf<Int>()
    for (f in buckets.indices.reversed()) {
        for (v in buckets[f]) {
            out.add(v)
            if (out.size == k) return out.toIntArray()
        }
    }
    return out.toIntArray()
}
