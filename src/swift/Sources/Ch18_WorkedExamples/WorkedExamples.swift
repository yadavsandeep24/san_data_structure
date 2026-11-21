// Worked examples (four languages)
// Source: book/part-v/18-caching-strategies.md

final class LruCache<Key: Hashable, Value> {
    private let capacity: Int
    private var map: [Key: Value] = [:]
    private var order: [Key] = [] // index 0 = LRU

    init(capacity: Int) { self.capacity = max(1, capacity) }

    func get(_ key: Key) -> Value? {
        guard let value = map[key] else { return nil }
        touch(key)
        return value
    }

    func put(_ key: Key, _ value: Value) {
        if map[key] != nil {
            map[key] = value
            touch(key)
            return
        }
        if order.count >= capacity, let evict = order.first {
            order.removeFirst()
            map.removeValue(forKey: evict)
        }
        map[key] = value
        order.append(key)
    }

    private func touch(_ key: Key) {
        if let i = order.firstIndex(of: key) {
            order.remove(at: i)
            order.append(key)
        }
    }
}

struct Entry<V> {
    let value: V
    let expiresAtMillis: Int64
}

func getIfFresh<V>(_ map: [String: Entry<V>], _ key: String, now: Int64) -> V? {
    guard let e = map[key] else { return nil }
    if now >= e.expiresAtMillis { return nil } // treat as miss
    return e.value
}
