// Q8. Minimum Window Substring (Shortest Log Span Covering All Events)
// Source: book/part-viii/32-two-pointers-windows-intervals.md
package ch32.q08_minimum_window_substring

fun minWindow(s: String, t: String): String {
    if (t.isEmpty() || t.length > s.length) return ""
    val need = IntArray(128)
    for (c in t) need[c.code]++
    var missing = t.length
    var left = 0
    var bestStart = 0
    var bestLen = Int.MAX_VALUE
    for (right in s.indices) {
        if (need[s[right].code]-- > 0) missing--
        while (missing == 0) {
            if (right - left + 1 < bestLen) {
                bestLen = right - left + 1
                bestStart = left
            }
            if (++need[s[left].code] > 0) missing++
            left++
        }
    }
    return if (bestLen == Int.MAX_VALUE) "" else s.substring(bestStart, bestStart + bestLen)
}
