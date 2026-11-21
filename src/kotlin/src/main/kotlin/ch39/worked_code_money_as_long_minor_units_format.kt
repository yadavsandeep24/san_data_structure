// Worked code (a) — Money as Long minor units + format
// Source: book/part-ix/39-money-idempotency-reliability.md
package ch39.worked_code_money_as_long_minor_units_format

data class Money(val amountMinor: Long, val currencyCode: String) {
    init { require(currencyCode.length == 3) { "ISO 4217 code required" } }

    operator fun plus(o: Money): Money {
        require(currencyCode == o.currencyCode) { "currency mismatch" }
        return Money(amountMinor + o.amountMinor, currencyCode)
    }

    fun format(locale: java.util.Locale = java.util.Locale.US): String {
        val nf = java.text.NumberFormat.getCurrencyInstance(locale)
        nf.currency = java.util.Currency.getInstance(currencyCode)
        // Divide only for display; never persist the Double.
        return nf.format(amountMinor.toDouble() / 100.0)
    }
}

/** Parse "199.99" → 19999 without floating intermediate for 2-decimal currencies. */
fun parseMajorToMinor(majorText: String, scale: Int = 2): Long {
    val cleaned = majorText.trim()
    val neg = cleaned.startsWith("-")
    val raw = if (neg) cleaned.drop(1) else cleaned
    val parts = raw.split('.')
    val whole = parts[0].toLong()
    val frac = if (parts.size == 1) 0L else parts[1].padEnd(scale, '0').take(scale).toLong()
    var pow = 1L
    repeat(scale) { pow *= 10 }
    val minor = whole * pow + frac
    return if (neg) -minor else minor
}
