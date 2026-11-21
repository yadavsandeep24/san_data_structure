// Q2. Two Sum II: Input Array Is Sorted (Sorted Price Pair)
// Source: book/part-viii/32-two-pointers-windows-intervals.md

func twoSumSorted(_ numbers: [Int], _ target: Int) -> [Int] {
    var i = 0
    var j = numbers.count - 1
    while i < j {
        let sum = numbers[i] + numbers[j]
        if sum == target { return [i + 1, j + 1] }
        if sum < target { i += 1 } else { j -= 1 }
    }
    return []
}
