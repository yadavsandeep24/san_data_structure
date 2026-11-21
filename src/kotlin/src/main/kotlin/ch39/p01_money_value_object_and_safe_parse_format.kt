// P1: Money value object and safe parse/format
// Source: solutions/ch39/README.md
package ch39.p01_money_value_object_and_safe_parse_format

data class Money(val amountMinor: Long, val currencyCode: String) {
    init { require(currencyCode.length == 3) }

    operator fun plus(o: Money): Money {
        require(currencyCode == o.currencyCode)
        return Money(amountMinor + o.amountMinor, currencyCode)
    }

    fun format(locale: java.util.Locale = java.util.Locale.US): String {
        val nf = java.text.NumberFormat.getCurrencyInstance(locale)
        nf.currency = java.util.Currency.getInstance(currencyCode)
        return nf.format(amountMinor.toDouble() / 100.0)
    }
}

fun parseMajorToMinor(text: String, scale: Int = 2): Long {
    val t = text.trim()
    require(t.isNotEmpty())
    val neg = t.startsWith("-")
    val raw = if (neg) t.drop(1) else t
    require(raw.matches(Regex("""\d+(\.\d+)?""")))
    val parts = raw.split('.')
    val whole = parts[0].toLong()
    var pow = 1L
    repeat(scale) { pow *= 10 }
    val frac = if (parts.size == 1) 0L else parts[1].padEnd(scale, '0').take(scale).toLong()
    val minor = whole * pow + frac
    return if (neg) -minor else minor
}
