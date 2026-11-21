// Worked example 1: dedupe a sorted array in place (read/write)
// Source: book/part-iv/13-two-pointers.md
package ch13.worked_example_1_dedupe_a_sorted_array_in_place

fun dedupeSortedInPlace(a: IntArray): Int {
    if (a.isEmpty()) return 0
    var write = 1                          // a[0] is always kept
    for (read in 1 until a.size) {
        if (a[read] != a[write - 1]) {     // new value
            a[write] = a[read]
            write++
        }
    }
    return write                           // a[0 until write] is the result
}
