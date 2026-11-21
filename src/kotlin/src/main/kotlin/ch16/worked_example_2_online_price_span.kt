// Worked example 2: online price span (answer after popping)
// Source: book/part-iv/16-monotonic-stack-deque.md
package ch16.worked_example_2_online_price_span

class PriceSpan {
    private val prices = ArrayDeque<Int>()
    private val spans = ArrayDeque<Int>()
    fun next(price: Int): Int {
        var span = 1
        while (prices.isNotEmpty() && prices.last() <= price) {
            prices.removeLast()
            span += spans.removeLast()
        }
        prices.addLast(price)
        spans.addLast(span)
        return span
    }
}
