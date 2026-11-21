// Q34. Reverse Words in a String
// Source: book/part-viii/29-interview-questions-q31-q40.md
package ch29.q34_reverse_words_in_a_string

fun reverseWords(s: String): String =
    s.trim().split(Regex("\\s+")).reversed().joinToString(" ")
