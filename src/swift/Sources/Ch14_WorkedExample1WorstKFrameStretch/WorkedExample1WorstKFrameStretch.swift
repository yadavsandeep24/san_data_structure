// Worked example 1: worst k-frame stretch (fixed window)
// Source: book/part-iv/14-sliding-window.md

func maxWindowSum(_ frames: [Int], _ k: Int) -> Int {
    var sum = frames[0..<k].reduce(0, +)
    var best = sum
    for right in k..<frames.count {
        sum += frames[right] - frames[right - k]
        best = max(best, sum)
    }
    return best
}
