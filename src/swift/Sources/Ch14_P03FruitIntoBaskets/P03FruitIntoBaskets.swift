// P3: Fruit into baskets (at most two kinds)
// Source: solutions/ch14/README.md

func totalFruit(_ types: [Int]) -> Int {
    var count: [Int: Int] = [:]
    var left = 0, best = 0
    for right in types.indices {
        count[types[right], default: 0] += 1
        while count.count > 2 {
            let t = types[left]
            count[t]! -= 1
            if count[t] == 0 { count[t] = nil }
            left += 1
        }
        best = max(best, right - left + 1)
    }
    return best
}
