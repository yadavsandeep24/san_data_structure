// P3: Sort colors (three-way partition)
// Source: solutions/ch13/README.md
package ch13.p03_sort_colors

fun sortColors(a: IntArray) {
    var low = 0
    var mid = 0
    var high = a.size - 1
    while (mid <= high) {
        when (a[mid]) {
            0 -> { a[mid] = a[low].also { a[low] = a[mid] }; low++; mid++ }
            1 -> mid++
            else -> { a[mid] = a[high].also { a[high] = a[mid] }; high-- }
        }
    }
}
