// Q3. Largest Rectangle in Histogram (Biggest Banner in a Bar Chart)
// Source: book/part-viii/33-stacks-binary-search.md
package ch33.q03_largest_rectangle_in_histogram

fun largestRectangleArea(heights: IntArray): Int {
    val stack = ArrayDeque<Int>() // indices, heights increasing
    var best = 0
    for (i in 0..heights.size) {
        val h = if (i == heights.size) 0 else heights[i] // sentinel flushes the stack
        while (stack.isNotEmpty() && heights[stack.last()] >= h) {
            val height = heights[stack.removeLast()]
            val left = if (stack.isEmpty()) -1 else stack.last()
            best = maxOf(best, height * (i - left - 1))
        }
        stack.addLast(i)
    }
    return best
}
