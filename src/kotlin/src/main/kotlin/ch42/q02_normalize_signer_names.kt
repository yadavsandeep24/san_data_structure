// Q2. Normalize Signer Names (Duplicate Recipients)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md
package ch42.q02_normalize_signer_names

import java.text.Normalizer

private val marks = Regex("\\p{Mn}+")
private val separators = Regex("[\\s,]+")

fun canonical(name: String): String =
    Normalizer.normalize(name, Normalizer.Form.NFD)
        .replace(marks, "")            // José -> Jose
        .lowercase()
        .split(separators)
        .filter { it.isNotEmpty() }
        .sorted()                       // "Doe, Jane" == "Jane Doe"
        .joinToString(" ")

fun duplicateGroups(names: List<String>): List<List<String>> =
    names.groupBy(::canonical).values.filter { it.size > 1 }
