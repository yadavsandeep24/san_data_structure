// Worked code: append vs insert front
// Source: book/part-ii/03-arrays-dynamic-arrays.md
package ch03.worked_code_append_vs_insert_front

val end = ArrayList<Int>(4)
fun example() {
    end.add(1)          // O(1) amortized
    end.add(0, 99)      // O(n) — shifts right
}

val frontHeavy = ArrayDeque<Int>() // better for front ops — Chapter 6
