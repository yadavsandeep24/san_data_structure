// Q4. Container With Most Water (Widest Chart Band)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

func maxArea(_ height: [Int]) -> Int {
    var i = 0
    var j = height.count - 1
    var best = 0
    while i < j {
        best = max(best, (j - i) * min(height[i], height[j]))
        if height[i] < height[j] { i += 1 } else { j -= 1 }
    }
    return best
}
