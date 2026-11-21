// P2: Contiguous array (equal 0s and 1s)
// Source: solutions/ch15/README.md
package ch15.p02_contiguous_array

fun findMaxLength(a: IntArray): Int {
    val first = HashMap<Int, Int>().apply { put(0, -1) }
    var prefix = 0
    var best = 0
    for (i in a.indices) {
        prefix += if (a[i] == 1) 1 else -1
        val f = first[prefix]
        if (f != null) best = maxOf(best, i - f) else first[prefix] = i
    }
    return best
}
