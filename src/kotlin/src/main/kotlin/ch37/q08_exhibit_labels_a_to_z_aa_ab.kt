// Q8. Exhibit Labels A to Z, AA, AB (Legal Exhibits)
// Source: book/part-viii/37-math-and-number-drills.md
package ch37.q08_exhibit_labels_a_to_z_aa_ab

fun columnTitle(number: Int): String {
    require(number > 0)
    val sb = StringBuilder()
    var n = number
    while (n > 0) {
        n--                                             // shift to 0-based: A..Z is 0..25 in each position
        sb.append('A' + n % 26)
        n /= 26
    }
    return sb.reverse().toString()
}

fun columnNumber(title: String): Int {
    require(title.isNotEmpty())
    return title.fold(0) { acc, c ->
        require(c in 'A'..'Z') { "not a label: $title" }
        Math.addExact(Math.multiplyExact(acc, 26), c - 'A' + 1)   // throw instead of wrapping past Int.MAX_VALUE
    }
}
