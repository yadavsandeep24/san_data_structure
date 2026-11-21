// Worked example 1: O(1) spend between two days
// Source: book/part-iv/15-prefix-sums.md

struct SpendRanges {
    private var prefix: [Int]
    init(_ daily: [Int]) {
        prefix = [0]
        prefix.reserveCapacity(daily.count + 1)
        for x in daily { prefix.append(prefix.last! + x) }
    }
    func total(_ from: Int, _ to: Int) -> Int { prefix[to + 1] - prefix[from] }
}
