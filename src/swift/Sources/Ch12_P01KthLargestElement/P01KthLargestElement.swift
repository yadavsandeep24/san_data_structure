// P1: Kth largest element
// Source: solutions/ch12/README.md

func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
    var heap = MinHeap()
    for x in nums {
        heap.push(x)
        if heap.count > k { _ = heap.pop() }
    }
    return heap.peek!
}

struct MinHeap {
    private var a: [Int] = []
    var count: Int { a.count }
    var peek: Int? { a.first }
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
            if a[i] >= a[p] { break }
            a.swapAt(i, p); i = p
        }
    }
    private mutating func siftDown(_ i: Int) {
        var i = i
        while true {
            var best = i
            let l = 2 * i + 1, r = l + 1
            if l < a.count && a[l] < a[best] { best = l }
            if r < a.count && a[r] < a[best] { best = r }
            if best == i { break }
            a.swapAt(i, best); i = best
        }
    }
}
