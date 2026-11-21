// Q3. 3Sum (Zero-Net Settlement Triples)
// Source: book/part-viii/32-two-pointers-windows-intervals.md
package ch32.q03_3sum

fun threeSum(nums: IntArray): List<List<Int>> {
    val a = nums.sorted()
    val out = mutableListOf<List<Int>>()
    for (i in a.indices) {
        if (a[i] > 0) break
        if (i > 0 && a[i] == a[i - 1]) continue
        var lo = i + 1
        var hi = a.size - 1
        while (lo < hi) {
            val sum = a[i].toLong() + a[lo] + a[hi]
            when {
                sum < 0 -> lo++
                sum > 0 -> hi--
                else -> {
                    out.add(listOf(a[i], a[lo], a[hi]))
                    lo++
                    hi--
                    while (lo < hi && a[lo] == a[lo - 1]) lo++
                }
            }
        }
    }
    return out
}
