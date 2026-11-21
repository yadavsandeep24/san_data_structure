// Q11. Short IDs in Base 62 (Signing Link Codes)
// Source: book/part-viii/37-math-and-number-drills.md
package ch37.q11_short_ids_in_base_62

private const val ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

fun toBase62(value: Long): String {
    require(value >= 0)
    if (value == 0L) return "0"
    val sb = StringBuilder()
    var v = value
    while (v > 0) {
        sb.append(ALPHABET[(v % 62).toInt()])
        v /= 62
    }
    return sb.reverse().toString()
}

fun fromBase62(text: String): Long {
    require(text.isNotEmpty())
    return text.fold(0L) { acc, c ->
        val digit = ALPHABET.indexOf(c)
        require(digit >= 0) { "not base62: $c" }
        Math.addExact(Math.multiplyExact(acc, 62L), digit.toLong())   // throw instead of silently wrapping
    }
}
