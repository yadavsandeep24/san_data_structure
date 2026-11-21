// Worked example 1: O(1) spend between two days
// Source: book/part-iv/15-prefix-sums.md
package ch15.worked_example_1_o_spend_between_two_days

class SpendRanges(daily: LongArray) {
    private val prefix = LongArray(daily.size + 1)
    init {
        for (i in daily.indices) prefix[i + 1] = prefix[i] + daily[i]
    }
    /** Total for days from..to inclusive, 0-based. */
    fun total(from: Int, to: Int): Long = prefix[to + 1] - prefix[from]
}
