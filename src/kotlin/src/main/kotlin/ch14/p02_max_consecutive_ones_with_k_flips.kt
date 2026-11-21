// P2: Max consecutive ones with k flips
// Source: solutions/ch14/README.md
package ch14.p02_max_consecutive_ones_with_k_flips

fun longestOnes(a: IntArray, k: Int): Int {
    var left = 0
    var zeros = 0
    var best = 0
    for (right in a.indices) {
        if (a[right] == 0) zeros++
        while (zeros > k) {
            if (a[left] == 0) zeros--
            left++
        }
        best = maxOf(best, right - left + 1)
    }
    return best
}
