// Q2. Two Sum II: Input Array Is Sorted (Sorted Price Pair)
// Source: book/part-viii/32-two-pointers-windows-intervals.md
package ch32.q02_two_sum_ii_input_array_is_sorted

fun twoSumSorted(numbers: IntArray, target: Int): IntArray {
    var i = 0
    var j = numbers.size - 1
    while (i < j) {
        val sum = numbers[i].toLong() + numbers[j]
        when {
            sum == target.toLong() -> return intArrayOf(i + 1, j + 1)
            sum < target -> i++
            else -> j--
        }
    }
    return intArrayOf()
}
