// P1: Next greater element, circular
// Source: solutions/ch16/README.md
package ch16.p01_next_greater_element_circular

fun nextGreaterCircular(a: IntArray): IntArray {
    val n = a.size
    val ans = IntArray(n) { -1 }
    val stack = ArrayDeque<Int>()
    for (i in 0 until 2 * n) {
        val x = a[i % n]
        while (stack.isNotEmpty() && a[stack.last()] < x) ans[stack.removeLast()] = x
        if (i < n) stack.addLast(i)
    }
    return ans
}
