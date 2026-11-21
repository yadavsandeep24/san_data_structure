// Worked example 1: worst k-frame stretch (fixed window)
// Source: book/part-iv/14-sliding-window.md
package ch14.worked_example_1_worst_k_frame_stretch

fun maxWindowSum(frames: IntArray, k: Int): Int {
    var sum = 0
    for (i in 0 until k) sum += frames[i]
    var best = sum
    for (right in k until frames.size) {
        sum += frames[right] - frames[right - k]   // slide: add new, drop oldest
        if (sum > best) best = sum
    }
    return best
}
