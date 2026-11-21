// Q2. Daily Temperatures (Warmer-Day Countdown)
// Source: book/part-viii/33-stacks-binary-search.md
package ch33.q02_daily_temperatures

fun dailyTemperatures(temps: IntArray): IntArray {
    val ans = IntArray(temps.size)
    val stack = ArrayDeque<Int>() // indices, temperatures strictly decreasing
    for (i in temps.indices) {
        while (stack.isNotEmpty() && temps[stack.last()] < temps[i]) {
            val j = stack.removeLast()
            ans[j] = i - j
        }
        stack.addLast(i)
    }
    return ans
}
