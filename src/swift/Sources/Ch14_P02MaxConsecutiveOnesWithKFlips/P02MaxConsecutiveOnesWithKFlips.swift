// P2: Max consecutive ones with k flips
// Source: solutions/ch14/README.md

func longestOnes(_ a: [Int], _ k: Int) -> Int {
    var left = 0, zeros = 0, best = 0
    for right in a.indices {
        if a[right] == 0 { zeros += 1 }
        while zeros > k {
            if a[left] == 0 { zeros -= 1 }
            left += 1
        }
        best = max(best, right - left + 1)
    }
    return best
}
