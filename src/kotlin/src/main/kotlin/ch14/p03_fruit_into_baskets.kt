// P3: Fruit into baskets (at most two kinds)
// Source: solutions/ch14/README.md
package ch14.p03_fruit_into_baskets

fun totalFruit(types: IntArray): Int {
    val count = HashMap<Int, Int>()
    var left = 0
    var best = 0
    for (right in types.indices) {
        count[types[right]] = (count[types[right]] ?: 0) + 1
        while (count.size > 2) {
            val t = types[left]
            val c = count.getValue(t) - 1
            if (c == 0) count.remove(t) else count[t] = c
            left++
        }
        best = maxOf(best, right - left + 1)
    }
    return best
}
