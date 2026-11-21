// Worked example 1: next higher price (answer on pop)
// Source: book/part-iv/16-monotonic-stack-deque.md
package ch16.worked_example_1_next_higher_price

fun nextGreaterValues(prices: IntArray): IntArray {
    val ans = IntArray(prices.size) { -1 }
    val stack = ArrayDeque<Int>()               // indices; values decreasing bottom→top
    for (i in prices.indices) {
        while (stack.isNotEmpty() && prices[stack.last()] < prices[i]) {
            ans[stack.removeLast()] = prices[i] // i is the next greater for the popped index
        }
        stack.addLast(i)
    }
    return ans                                  // indices left on the stack keep -1
}
