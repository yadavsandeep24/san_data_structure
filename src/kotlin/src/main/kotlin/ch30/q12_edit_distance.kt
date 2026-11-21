// Q12. Edit Distance
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md
package ch30.q12_edit_distance

fun minDistance(word1: String, word2: String): Int {
    val m = word1.length
    val n = word2.length
    var prev = IntArray(n + 1) { it }
    for (i in 1..m) {
        val cur = IntArray(n + 1)
        cur[0] = i
        for (j in 1..n) {
            cur[j] = if (word1[i - 1] == word2[j - 1]) prev[j - 1]
            else 1 + minOf(prev[j], cur[j - 1], prev[j - 1])
        }
        prev = cur
    }
    return prev[n]
}
