// Q2. Trapping Rain Water (Price Spike Wells)
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md
package ch30.q02_trapping_rain_water

fun trap(height: IntArray): Int {
    var lo = 0
    var hi = height.lastIndex
    var leftMax = 0
    var rightMax = 0
    var water = 0
    while (lo < hi) {
        if (height[lo] <= height[hi]) {
            if (height[lo] >= leftMax) leftMax = height[lo]
            else water += leftMax - height[lo]
            lo++
        } else {
            if (height[hi] >= rightMax) rightMax = height[hi]
            else water += rightMax - height[hi]
            hi--
        }
    }
    return water
}
