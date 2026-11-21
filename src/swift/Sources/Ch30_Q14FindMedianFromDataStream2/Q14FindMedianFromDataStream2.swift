// Q14: Find median from data stream (TypeScript two-heap or Swift or Dart)
// Source: solutions/ch30/README.md

final class MedianFinder {
    private var low: [Int] = [] // max-heap
    private var high: [Int] = [] // min-heap

    func addNum(_ num: Int) {
        low.append(num); low.sort(by: >)
        high.append(low.removeFirst()); high.sort()
        if high.count > low.count {
            low.append(high.removeFirst()); low.sort(by: >)
        }
    }

    func findMedian() -> Double {
        if low.count > high.count { return Double(low[0]) }
        return Double(low[0] + high[0]) / 2.0
    }
}
