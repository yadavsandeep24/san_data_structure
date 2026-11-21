// Q25. Kth Largest Element
// Source: book/part-viii/29-interview-questions-q21-q30.md

// Min-heap via array for interview clarity
func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
    var heap = [Int]()
    func siftUp(_ i: Int) {
        var i = i
        while i > 0 {
            let p = (i - 1) / 2
            if heap[p] <= heap[i] { break }
            heap.swapAt(p, i); i = p
        }
    }
    func siftDown(_ i: Int) {
        var i = i
        while true {
            var s = i
            let l = 2 * i + 1, r = l + 1
            if l < heap.count && heap[l] < heap[s] { s = l }
            if r < heap.count && heap[r] < heap[s] { s = r }
            if s == i { break }
            heap.swapAt(i, s); i = s
        }
    }
    for x in nums {
        if heap.count < k { heap.append(x); siftUp(heap.count - 1) }
        else if x > heap[0] { heap[0] = x; siftDown(0) }
    }
    return heap[0]
}
