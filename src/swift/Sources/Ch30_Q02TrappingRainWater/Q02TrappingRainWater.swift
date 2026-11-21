// Q2. Trapping Rain Water (Price Spike Wells)
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

func trap(_ height: [Int]) -> Int {
    var lo = 0, hi = height.count - 1, leftMax = 0, rightMax = 0, water = 0
    while lo < hi {
        if height[lo] <= height[hi] {
            if height[lo] >= leftMax { leftMax = height[lo] } else { water += leftMax - height[lo] }
            lo += 1
        } else {
            if height[hi] >= rightMax { rightMax = height[hi] } else { water += rightMax - height[hi] }
            hi -= 1
        }
    }
    return water
}
