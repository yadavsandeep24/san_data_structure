// P2: Remove k digits
// Source: solutions/ch16/README.md
package ch16.p02_remove_k_digits

fun removeKdigits(num: String, k: Int): String {
    var remaining = k
    val stack = StringBuilder()
    for (c in num) {
        while (remaining > 0 && stack.isNotEmpty() && stack.last() > c) {
            stack.setLength(stack.length - 1)
            remaining--
        }
        stack.append(c)
    }
    stack.setLength(stack.length - remaining)
    val result = stack.trimStart('0').toString()
    return result.ifEmpty { "0" }
}
