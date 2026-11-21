// Worked example 2: longest prefetch run within a byte budget (variable window)
// Source: book/part-iv/14-sliding-window.md

func longestWithinBudget(_ sizes: [Int], _ budget: Int) -> Int {
    var left = 0, sum = 0, best = 0
    for right in sizes.indices {
        sum += sizes[right]
        while sum > budget {
            sum -= sizes[left]
            left += 1
        }
        best = max(best, right - left + 1)
    }
    return best
}
