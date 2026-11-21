// Q3 — Task Scheduler (Swift / Dart)
// Source: solutions/ch35/README.md

func leastInterval(_ tasks: [Character], _ n: Int) -> Int {
    var freq = [Int](repeating: 0, count: 26)
    for t in tasks {
        guard let v = t.asciiValue, v >= 65, v <= 90 else { continue } // labels are 'A'...'Z'
        freq[Int(v) - 65] += 1
    }
    guard let maxF = freq.max(), maxF > 0 else { return 0 }
    let maxCount = freq.filter { $0 == maxF }.count
    return max(tasks.count, (maxF - 1) * (n + 1) + maxCount)
}
