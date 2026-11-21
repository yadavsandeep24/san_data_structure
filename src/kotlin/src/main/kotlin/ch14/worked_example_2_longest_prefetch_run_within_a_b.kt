// Worked example 2: longest prefetch run within a byte budget (variable window)
// Source: book/part-iv/14-sliding-window.md
package ch14.worked_example_2_longest_prefetch_run_within_a_b

fun longestWithinBudget(sizes: IntArray, budget: Int): Int {
    var left = 0
    var sum = 0L
    var best = 0
    for (right in sizes.indices) {
        sum += sizes[right]
        while (sum > budget) {          // shrink until valid again
            sum -= sizes[left]
            left++
        }
        best = maxOf(best, right - left + 1)
    }
    return best
}
