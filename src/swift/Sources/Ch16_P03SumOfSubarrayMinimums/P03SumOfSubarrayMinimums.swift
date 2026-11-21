// P3: Sum of subarray minimums
// Source: solutions/ch16/README.md

func sumSubarrayMins(_ a: [Int]) -> Int {
    let mod = 1_000_000_007
    var stack: [Int] = []
    var total = 0
    for i in 0...a.count {
        let cur = i == a.count ? Int.min : a[i]
        while let j = stack.last, a[j] >= cur {
            stack.removeLast()
            let k = stack.last ?? -1
            total = (total + a[j] * (j - k) * (i - j)) % mod
        }
        stack.append(i)
    }
    return total
}
