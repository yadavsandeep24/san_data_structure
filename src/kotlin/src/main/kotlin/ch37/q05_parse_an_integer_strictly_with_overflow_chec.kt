// Q5. Parse an Integer Strictly, with Overflow Checks (Page Number Input)
// Source: book/part-viii/37-math-and-number-drills.md
package ch37.q05_parse_an_integer_strictly_with_overflow_chec

fun parseIntStrict(s: String): Int? {
    if (s.isEmpty()) return null
    val negative = s[0] == '-'
    val start = if (s[0] == '-' || s[0] == '+') 1 else 0
    if (start == s.length) return null                  // a lone sign
    var value = 0                                       // built as a negative: Int.MIN_VALUE has no positive twin
    for (i in start until s.length) {
        val digit = s[i] - '0'
        if (digit !in 0..9) return null
        if (value < (Int.MIN_VALUE + digit) / 10) return null   // value * 10 - digit would overflow
        value = value * 10 - digit
    }
    return if (negative) value else if (value == Int.MIN_VALUE) null else -value
}
