// Worked example 2: is the query a subsequence of the name? (one cursor per sequence)
// Source: book/part-iv/13-two-pointers.md
package ch13.worked_example_2_is_the_query_a_subsequence_of_t

fun isSubsequence(query: String, name: String): Boolean {
    var qi = 0
    for (ch in name) {
        if (qi == query.length) break
        if (ch.lowercaseChar() == query[qi].lowercaseChar()) qi++
    }
    return qi == query.length
}
