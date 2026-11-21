// P2: Top K frequent
// Source: solutions/ch12/README.md

func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
    var freq: [Int: Int] = [:]
    for x in nums { freq[x, default: 0] += 1 }
    var heap = MinHeapPair() // min by freq
    for (v, f) in freq {
        heap.push(f, v)
        if heap.count > k { _ = heap.pop() }
    }
    var out: [Int] = []
    while let p = heap.pop() { out.append(p.value) }
    return out
}

struct MinHeapPair {
    struct Node { var freq: Int; var value: Int }
    private var a: [Node] = []
    var count: Int { a.count }
    mutating func push(_ freq: Int, _ value: Int) {
        a.append(Node(freq: freq, value: value)); siftUp(a.count - 1)
    }
    mutating func pop() -> Node? {
        guard let first = a.first else { return nil }
        a[0] = a.last!; a.removeLast()
        if !a.isEmpty { siftDown(0) }
        return first
    }
    private mutating func siftUp(_ i: Int) {
        var i = i
        while i > 0 {
            let p = (i - 1) / 2
            if a[i].freq >= a[p].freq { break }
            a.swapAt(i, p); i = p
        }
    }
    private mutating func siftDown(_ i: Int) {
        var i = i
        while true {
            var best = i
            let l = 2 * i + 1, r = l + 1
            if l < a.count && a[l].freq < a[best].freq { best = l }
            if r < a.count && a[r].freq < a[best].freq { best = r }
            if best == i { break }
            a.swapAt(i, best); i = best
        }
    }
}
