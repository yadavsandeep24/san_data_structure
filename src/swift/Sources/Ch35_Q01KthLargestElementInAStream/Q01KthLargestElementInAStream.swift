// Q1. Kth Largest Element in a Stream (Live Leaderboard Cutoff)
// Source: book/part-viii/35-heaps-tries-greedy.md

struct Heap<T> {
    private var items: [T] = []
    private let less: (T, T) -> Bool
    init(_ less: @escaping (T, T) -> Bool) { self.less = less }

    var count: Int { items.count }
    var peek: T? { items.first }

    mutating func push(_ x: T) {
        items.append(x)
        var i = items.count - 1
        while i > 0 {
            let p = (i - 1) / 2
            if !less(items[i], items[p]) { break }
            items.swapAt(i, p)
            i = p
        }
    }

    @discardableResult
    mutating func pop() -> T? {
        guard !items.isEmpty else { return nil }
        items.swapAt(0, items.count - 1)
        let top = items.removeLast()
        var i = 0
        while true {
            let l = 2 * i + 1, r = l + 1
            var m = i
            if l < items.count && less(items[l], items[m]) { m = l }
            if r < items.count && less(items[r], items[m]) { m = r }
            if m == i { break }
            items.swapAt(i, m)
            i = m
        }
        return top
    }
}

final class KthLargest {
    private let k: Int
    private var heap = Heap<Int>(<) // min-heap of the top k

    init(_ k: Int, _ nums: [Int]) {
        self.k = k
        for x in nums { _ = add(x) }
    }

    func add(_ val: Int) -> Int {
        heap.push(val)
        if heap.count > k { heap.pop() }
        return heap.peek ?? Int.min
    }
}
