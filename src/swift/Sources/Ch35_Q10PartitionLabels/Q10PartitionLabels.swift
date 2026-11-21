// Q10. Partition Labels (Chunking a Sync Log)
// Source: book/part-viii/35-heaps-tries-greedy.md

func partitionLabels(_ s: String) -> [Int] {
    let chars = Array(s)
    var last: [Character: Int] = [:]
    for (i, c) in chars.enumerated() { last[c] = i }
    var sizes: [Int] = []
    var start = 0, end = 0
    for (i, c) in chars.enumerated() {
        end = max(end, last[c] ?? i)
        if i == end {
            sizes.append(end - start + 1)
            start = i + 1
        }
    }
    return sizes
}
