// Q6. Halve the Largest k Times (Compress the Biggest Attachments)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

/// Array-backed max-heap of Ints.
struct MaxHeap {
    private var a: [Int] = []
    var isEmpty: Bool { a.isEmpty }

    mutating func push(_ x: Int) {
        a.append(x)
        var i = a.count - 1
        while i > 0 {
            let p = (i - 1) / 2
            if a[p] >= a[i] { break }
            a.swapAt(p, i); i = p
        }
    }

    mutating func pop() -> Int? {
        guard let top = a.first else { return nil }
        let last = a.removeLast()
        if !a.isEmpty {
            a[0] = last
            var i = 0
            while true {
                let l = 2 * i + 1, r = l + 1
                var m = i
                if l < a.count && a[l] > a[m] { m = l }
                if r < a.count && a[r] > a[m] { m = r }
                if m == i { break }
                a.swapAt(m, i); i = m
            }
        }
        return top
    }
}

func minSumAfterHalving(_ nums: [Int], _ k: Int) -> Int {
    var heap = MaxHeap()
    nums.forEach { heap.push($0) }
    var sum = nums.reduce(0, +)
    for _ in 0..<max(0, k) {
        guard let top = heap.pop() else { break }
        let half = top - top / 2          // ceil(top / 2)
        sum -= top - half
        heap.push(half)
    }
    return sum
}
