// P1: Read the cost
// Source: solutions/ch02/README.md
package ch02.p01_read_the_cost

fun doubled(a: List<Int>): List<Int> {
    val out = ArrayList<Int>(a.size)   // presizing avoids regrowth
    for (x in a) out.add(x * 2)
    return out
}

fun commonNaive(a: List<String>, b: List<String>): List<String> =
    a.filter { b.contains(it) }        // contains is a linear scan of b

fun hasDuplicateBySort(a: IntArray): Boolean {
    val s = a.sortedArray()             // copy + sort
    for (i in 1 until s.size) if (s[i] == s[i - 1]) return true
    return false
}
