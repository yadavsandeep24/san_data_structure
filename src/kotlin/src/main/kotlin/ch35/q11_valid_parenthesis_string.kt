// Q11. Valid Parenthesis String (Template Brackets with Wildcards)
// Source: book/part-viii/35-heaps-tries-greedy.md
package ch35.q11_valid_parenthesis_string

fun checkValidString(s: String): Boolean {
    var lo = 0 // fewest open brackets possible
    var hi = 0 // most open brackets possible
    for (c in s) {
        when (c) {
            '(' -> { lo++; hi++ }
            ')' -> { lo--; hi-- }
            else -> { lo--; hi++ } // '*' as ')' or '('
        }
        if (hi < 0) return false
        if (lo < 0) lo = 0
    }
    return lo == 0
}
