// P3: Last stone weight
// Source: solutions/ch12/README.md

func lastStoneWeight(_ stones: [Int]) -> Int {
    var h = MaxHeap()
    for s in stones { h.push(s) }
    while h.count > 1 {
        let x = h.pop()!
        let y = h.pop()!
        if x != y { h.push(x - y) }
    }
    return h.pop() ?? 0
}

struct MaxHeap {
    private var a: [Int] = []
    var count: Int { a.count }
    mutating func push(_ x: Int) {
        a.append(x); siftUp(a.count - 1)
    }
    mutating func pop() -> Int? {
        guard let first = a.first else { return nil }
        a[0] = a.last!; a.removeLast()
        if !a.isEmpty { siftDown(0) }
        return first
    }
    private mutating func siftUp(_ i: Int) {
        var i = i
        while i > 0 {
            let p = (i - 1) / 2
            if a[i] <= a[p] { break }
            a.swapAt(i, p); i = p
        }
    }
    private mutating func siftDown(_ i: Int) {
        var i = i
        while true {
            var best = i
            let l = 2 * i + 1, r = l + 1
            if l < a.count && a[l] > a[best] { best = l }
            if r < a.count && a[r] > a[best] { best = r }
            if best == i { break }
            a.swapAt(i, best); i = best
        }
    }
}
