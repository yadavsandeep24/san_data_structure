// Q1. Valid Palindrome (Coupon Code Check)
// Source: book/part-viii/32-two-pointers-windows-intervals.md
package ch32.q01_valid_palindrome

fun isPalindrome(s: String): Boolean {
    fun norm(c: Char): Char? = when (c) {
        in 'a'..'z', in '0'..'9' -> c
        in 'A'..'Z' -> c + ('a' - 'A')
        else -> null
    }
    var i = 0
    var j = s.length - 1
    while (i < j) {
        val a = norm(s[i])
        val b = norm(s[j])
        when {
            a == null -> i++
            b == null -> j--
            a != b -> return false
            else -> { i++; j-- }
        }
    }
    return true
}
