// Q3. 3Sum (Zero-Net Settlement Triples)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

func threeSum(_ nums: [Int]) -> [[Int]] {
    let a = nums.sorted()
    var out: [[Int]] = []
    for i in 0..<a.count {
        if a[i] > 0 { break }
        if i > 0 && a[i] == a[i - 1] { continue }
        var lo = i + 1, hi = a.count - 1
        while lo < hi {
            let sum = a[i] + a[lo] + a[hi]
            if sum < 0 { lo += 1 }
            else if sum > 0 { hi -= 1 }
            else {
                out.append([a[i], a[lo], a[hi]])
                lo += 1
                hi -= 1
                while lo < hi && a[lo] == a[lo - 1] { lo += 1 }
            }
        }
    }
    return out
}
