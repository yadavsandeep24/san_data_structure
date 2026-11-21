// P3: Car pooling (capacity check)
// Source: solutions/ch15/README.md
package ch15.p03_car_pooling

fun carPooling(trips: Array<IntArray>, capacity: Int): Boolean {
    val diff = IntArray(1001)
    for ((p, from, to) in trips) {
        diff[from] += p
        diff[to] -= p
    }
    var onBoard = 0
    for (d in diff) {
        onBoard += d
        if (onBoard > capacity) return false
    }
    return true
}
