// Worked code: sets in four languages
// Source: book/part-iii/08-sets.md
package ch08.worked_code_sets_in_four_languages

val seen = HashSet<String>()
fun example() {
    seen.add("p1")
    seen.add("p1")                 // no-op; size stays 1
    println("p1" in seen)          // true
}

val ordered = LinkedHashSet<String>()
fun example2() {
    ordered.add("first")
    ordered.add("second")
    println(ordered.toList())      // [first, second]
}
