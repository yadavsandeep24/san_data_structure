// Q7. Count Balanced Binary Substrings (Pen-Down Runs)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md
package ch42.q07_count_balanced_binary_substrings

fun countBinarySubstrings(s: String): Int {
    var previous = 0
    var current = 1
    var count = 0
    for (i in 1 until s.length) {
        if (s[i] == s[i - 1]) {
            current++
        } else {
            count += minOf(previous, current)
            previous = current
            current = 1
        }
    }
    return count + minOf(previous, current)
}
