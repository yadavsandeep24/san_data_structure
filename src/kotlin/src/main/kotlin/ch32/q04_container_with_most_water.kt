// Q4. Container With Most Water (Widest Chart Band)
// Source: book/part-viii/32-two-pointers-windows-intervals.md
package ch32.q04_container_with_most_water

fun maxArea(height: IntArray): Int {
    var i = 0
    var j = height.size - 1
    var best = 0
    while (i < j) {
        best = maxOf(best, (j - i) * minOf(height[i], height[j]))
        if (height[i] < height[j]) i++ else j--
    }
    return best
}
