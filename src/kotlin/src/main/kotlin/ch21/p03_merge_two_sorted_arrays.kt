// P3: Merge two sorted arrays
// Source: solutions/ch21/README.md
package ch21.p03_merge_two_sorted_arrays

fun mergeSorted(a: IntArray, b: IntArray): IntArray {
    val out = IntArray(a.size + b.size)
    var i = 0
    var j = 0
    var k = 0
    while (i < a.size && j < b.size) {
        if (a[i] <= b[j]) out[k++] = a[i++] else out[k++] = b[j++]
    }
    while (i < a.size) out[k++] = a[i++]
    while (j < b.size) out[k++] = b[j++]
    return out
}
