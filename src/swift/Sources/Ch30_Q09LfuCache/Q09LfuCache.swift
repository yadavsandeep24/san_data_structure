// Q9. LFU Cache
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

/// Insertion-ordered key set: O(1) append / remove / first (doubly linked list over dictionaries).
struct OrderedKeySet {
    private var prev: [Int: Int] = [:]
    private var next: [Int: Int] = [:]
    private(set) var first: Int?
    private var last: Int?
    private(set) var count = 0
    var isEmpty: Bool { count == 0 }

    mutating func append(_ k: Int) {
        if let l = last { next[l] = k; prev[k] = l } else { first = k }
        last = k
        count += 1
    }

    /// Precondition: `k` is in the set.
    mutating func remove(_ k: Int) {
        let p = prev.removeValue(forKey: k), n = next.removeValue(forKey: k)
        if let p { next[p] = n } else { first = n }
        if let n { prev[n] = p } else { last = p }
        count -= 1
    }
}

final class LFUCache {
    private let cap: Int
    private var keyNode: [Int: (value: Int, freq: Int)] = [:]
    private var freqList: [Int: OrderedKeySet] = [:] // freq -> keys, LRU first
    private var minFreq = 0

    init(_ capacity: Int) { cap = capacity }

    func get(_ key: Int) -> Int {
        guard let n = keyNode[key] else { return -1 }
        touch(key, n)
        return n.value
    }

    func put(_ key: Int, _ value: Int) {
        guard cap > 0 else { return }
        if var n = keyNode[key] {
            n.value = value
            keyNode[key] = n
            touch(key, n)
            return
        }
        if keyNode.count >= cap, let evict = freqList[minFreq]?.first {
            freqList[minFreq]?.remove(evict)
            keyNode.removeValue(forKey: evict)
        }
        keyNode[key] = (value, 1)
        freqList[1, default: OrderedKeySet()].append(key)
        minFreq = 1
    }

    private func touch(_ key: Int, _ n: (value: Int, freq: Int)) {
        let f = n.freq
        freqList[f]?.remove(key)
        if freqList[f]?.isEmpty == true {
            freqList.removeValue(forKey: f)
            if minFreq == f { minFreq += 1 }
        }
        keyNode[key] = (n.value, f + 1)
        freqList[f + 1, default: OrderedKeySet()].append(key)
    }
}
