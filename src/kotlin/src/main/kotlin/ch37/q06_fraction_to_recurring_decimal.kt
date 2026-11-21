// Q6. Fraction to Recurring Decimal (Fee Split Display)
// Source: book/part-viii/37-math-and-number-drills.md
package ch37.q06_fraction_to_recurring_decimal
import java.math.BigInteger

fun fractionToDecimal(numerator: Long, denominator: Long): String {
    require(denominator != 0L)
    if (numerator == 0L) return "0"
    val sb = StringBuilder()
    if ((numerator < 0) != (denominator < 0)) sb.append('-')
    val n = BigInteger.valueOf(numerator).abs()         // abs(Long.MIN_VALUE) doesn't fit in a Long
    val d = BigInteger.valueOf(denominator).abs()
    sb.append(n / d)
    var remainder = n % d
    if (remainder == BigInteger.ZERO) return sb.toString()
    sb.append('.')
    val seenAt = HashMap<BigInteger, Int>()             // remainder -> where its digit was written
    while (remainder != BigInteger.ZERO) {
        seenAt[remainder]?.let { start ->
            sb.insert(start, '(').append(')')
            return sb.toString()
        }
        seenAt[remainder] = sb.length
        remainder *= BigInteger.TEN
        sb.append(remainder / d)
        remainder %= d
    }
    return sb.toString()
}
