// Q3. Largest Rectangle in Histogram (Biggest Banner in a Bar Chart)
// Source: book/part-viii/33-stacks-binary-search.md

func largestRectangleArea(_ heights: [Int]) -> Int {
    var stack: [Int] = [] // indices, heights increasing
    var best = 0
    for i in 0...heights.count {
        let h = i == heights.count ? 0 : heights[i] // sentinel flushes the stack
        while let top = stack.last, heights[top] >= h {
            stack.removeLast()
            let left = stack.last ?? -1
            best = max(best, heights[top] * (i - left - 1))
        }
        stack.append(i)
    }
    return best
}
