// Q3. Redact PII Before Logging (Crash Reports)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md
package ch42.q03_redact_pii_before_logging

private val email = Regex("""[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}""")
private val phone = Regex("""\+?\d[\d\s-]{8,}\d""")

fun redact(text: String): String =
    text.replace(email) { m ->
        val v = m.value
        v.first() + "***" + v.substring(v.indexOf('@'))
    }.replace(phone) { m ->
        val digits = m.value.filter(Char::isDigit)
        "•".repeat((digits.length - 4).coerceAtLeast(0)) + digits.takeLast(4)
    }
