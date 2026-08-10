// Sample: k largest values via size-k min-heap (Chapter 18)
func kLargest(_ nums: [Int], _ k: Int) -> [Int] {
    var heap: [Int] = []
    func siftUp(_ i0: Int) {
        var i = i0
        while i > 0 {
            let p = (i - 1) / 2
            if heap[i] >= heap[p] { break }
            heap.swapAt(i, p)
            i = p
        }
    }
    func siftDown(_ i0: Int) {
        var i = i0
        while true {
            var best = i
            let l = i * 2 + 1, r = l + 1
            if l < heap.count && heap[l] < heap[best] { best = l }
            if r < heap.count && heap[r] < heap[best] { best = r }
            if best == i { break }
            heap.swapAt(i, best)
            i = best
        }
    }
    for n in nums {
        heap.append(n)
        siftUp(heap.count - 1)
        if heap.count > k {
            let last = heap.removeLast()
            if !heap.isEmpty {
                heap[0] = last
                siftDown(0)
            }
        }
    }
    return heap.sorted(by: >)
}
