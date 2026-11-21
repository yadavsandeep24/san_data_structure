// Q4. Top K Frequent Elements
// Source: book/part-viii/29-interview-questions-q01-q10.md

func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
    var freq: [Int: Int] = [:]
    for x in nums { freq[x, default: 0] += 1 }
    var buckets = Array(repeating: [Int](), count: nums.count + 1)
    for (v, f) in freq { buckets[f].append(v) }
    var out: [Int] = []
    for f in stride(from: buckets.count - 1, through: 0, by: -1) {
        for v in buckets[f] {
            out.append(v)
            if out.count == k { return out }
        }
    }
    return out
}
