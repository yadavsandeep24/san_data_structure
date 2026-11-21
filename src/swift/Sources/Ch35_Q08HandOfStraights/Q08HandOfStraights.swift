// Q8. Hand of Straights (Consecutive Ticket Batches)
// Source: book/part-viii/35-heaps-tries-greedy.md

func isNStraightHand(_ hand: [Int], _ groupSize: Int) -> Bool {
    if hand.count % groupSize != 0 { return false }
    var count: [Int: Int] = [:]
    for h in hand { count[h, default: 0] += 1 }
    for first in count.keys.sorted() {
        let need = count[first] ?? 0 // groups that must start here
        if need == 0 { continue }
        for v in first..<(first + groupSize) {
            let have = count[v] ?? 0
            if have < need { return false }
            count[v] = have - need
        }
    }
    return true
}
