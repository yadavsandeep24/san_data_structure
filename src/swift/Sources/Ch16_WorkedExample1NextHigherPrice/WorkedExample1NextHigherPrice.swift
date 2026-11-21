// Worked example 1: next higher price (answer on pop)
// Source: book/part-iv/16-monotonic-stack-deque.md

func nextGreaterValues(_ prices: [Int]) -> [Int] {
    var ans = [Int](repeating: -1, count: prices.count)
    var stack: [Int] = []
    for i in prices.indices {
        while let top = stack.last, prices[top] < prices[i] {
            ans[top] = prices[i]
            stack.removeLast()
        }
        stack.append(i)
    }
    return ans
}
