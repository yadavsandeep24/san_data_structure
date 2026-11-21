// P4. Task Scheduler (Priority Queue)
// Source: solutions/ch38/README.md

final class TaskScheduler {
    private struct Job {
        let id: String
        let priority: Int
        let seq: Int
        let run: () -> Void
    }

    private var heap: [Job] = []
    private var cancelled = Set<String>()
    private var seq = 0

    func schedule(_ id: String, priority: Int, run: @escaping () -> Void) {
        heap.append(Job(id: id, priority: priority, seq: seq, run: run))
        seq += 1
        siftUp(heap.count - 1)
    }

    func cancel(_ id: String) { cancelled.insert(id) }

    func runNext() -> Bool {
        while let job = pop() {
            if cancelled.remove(job.id) != nil { continue }
            job.run()
            return true
        }
        return false
    }

    /// Higher priority first; tie-break earlier `seq`.
    private func before(_ a: Job, _ b: Job) -> Bool {
        a.priority != b.priority ? a.priority > b.priority : a.seq < b.seq
    }

    private func siftUp(_ start: Int) {
        var i = start
        while i > 0 {
            let p = (i - 1) / 2
            if !before(heap[i], heap[p]) { break }
            heap.swapAt(i, p)
            i = p
        }
    }

    private func siftDown(_ start: Int) {
        var i = start
        while true {
            var best = i
            let l = 2 * i + 1, r = l + 1
            if l < heap.count && before(heap[l], heap[best]) { best = l }
            if r < heap.count && before(heap[r], heap[best]) { best = r }
            if best == i { return }
            heap.swapAt(i, best)
            i = best
        }
    }

    private func pop() -> Job? {
        guard !heap.isEmpty else { return nil }
        heap.swapAt(0, heap.count - 1)
        let top = heap.removeLast()
        if !heap.isEmpty { siftDown(0) }
        return top
    }
}
