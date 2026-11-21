// Q14. Find Median from Data Stream
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md
package ch30.q14_find_median_from_data_stream

class MedianFinder {
    private val low = java.util.PriorityQueue<Int>(compareByDescending { it })
    private val high = java.util.PriorityQueue<Int>()

    fun addNum(num: Int) {
        low.add(num)
        high.add(low.poll())
        if (high.size > low.size) low.add(high.poll())
    }

    fun findMedian(): Double =
        if (low.size > high.size) low.peek().toDouble()
        else (low.peek() + high.peek()) / 2.0
}
