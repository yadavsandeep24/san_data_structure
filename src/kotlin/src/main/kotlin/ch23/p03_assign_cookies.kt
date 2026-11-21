// P3: Assign cookies
// Source: solutions/ch23/README.md
package ch23.p03_assign_cookies

fun findContentChildren(g: IntArray, s: IntArray): Int {
    g.sort()
    s.sort()
    var i = 0
    var j = 0
    while (i < g.size && j < s.size) {
        if (s[j] >= g[i]) i++
        j++
    }
    return i
}
