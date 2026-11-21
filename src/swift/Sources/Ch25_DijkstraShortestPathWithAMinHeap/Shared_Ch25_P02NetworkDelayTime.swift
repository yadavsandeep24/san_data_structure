// Types copied from Ch25_P02NetworkDelayTime so this problem compiles on its own.

struct MinHeapPair {
    private var a: [(Int, Int)] = []
    mutating func push(_ d: Int, _ u: Int) {
        a.append((d, u)); siftUp(a.count - 1)
    }
    mutating func pop() -> (Int, Int)? {
        guard let first = a.first else { return nil }
        a[0] = a.last!; a.removeLast()
        if !a.isEmpty { siftDown(0) }
        return first
    }
    private mutating func siftUp(_ i: Int) {
        var i = i
        while i > 0 {
            let p = (i - 1) / 2
            if a[i].0 >= a[p].0 { break }
            a.swapAt(i, p); i = p
        }
    }
    private mutating func siftDown(_ i: Int) {
        var i = i
        while true {
            var best = i
            let l = 2 * i + 1, r = l + 1
            if l < a.count && a[l].0 < a[best].0 { best = l }
            if r < a.count && a[r].0 < a[best].0 { best = r }
            if best == i { break }
            a.swapAt(i, best); i = best
        }
    }
}
