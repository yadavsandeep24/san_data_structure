// Q9. Time Based Key-Value Store (Versioned Config Cache)
// Source: book/part-viii/33-stacks-binary-search.md

final class TimeMap {
    private var store: [String: [(time: Int, value: String)]] = [:]

    // Timestamps for a key arrive in increasing order, so each list stays sorted.
    func set(_ key: String, _ value: String, _ timestamp: Int) {
        store[key, default: []].append((timestamp, value))
    }

    func get(_ key: String, _ timestamp: Int) -> String {
        guard let list = store[key] else { return "" }
        var lo = 0, hi = list.count - 1
        var ans = ""
        while lo <= hi { // last entry with time <= timestamp
            let mid = lo + (hi - lo) / 2
            if list[mid].time <= timestamp {
                ans = list[mid].value
                lo = mid + 1
            } else {
                hi = mid - 1
            }
        }
        return ans
    }
}
