// Types copied from Ch35_Q01KthLargestElementInAStream so this problem compiles on its own.

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
