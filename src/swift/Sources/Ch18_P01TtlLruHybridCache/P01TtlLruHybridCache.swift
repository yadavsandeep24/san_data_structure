// P1: TTL + LRU hybrid cache
// Source: solutions/ch18/README.md
import Foundation

final class TtlLruCache<Key: Hashable, Value> {
    private struct Entry {
        var value: Value
        var expiresAt: TimeInterval
    }

    private let capacity: Int
    private let clock: () -> TimeInterval
    private var map: [Key: Entry] = [:]
    private var order: [Key] = [] // 0 = LRU

    init(capacity: Int, clock: @escaping () -> TimeInterval = { Date().timeIntervalSince1970 }) {
        self.capacity = max(1, capacity)
        self.clock = clock
    }

    func get(_ key: Key) -> Value? {
        guard let e = map[key] else { return nil }
        if clock() >= e.expiresAt {
            removeKey(key)
            return nil
        }
        touch(key)
        return e.value
    }

    func put(_ key: Key, _ value: Value, ttl: TimeInterval) {
        if map[key] != nil {
            map[key] = Entry(value: value, expiresAt: clock() + ttl)
            touch(key)
            return
        }
        while order.count >= capacity {
            if let evict = order.first { removeKey(evict) }
        }
        map[key] = Entry(value: value, expiresAt: clock() + ttl)
        order.append(key)
    }

    private func touch(_ key: Key) {
        if let i = order.firstIndex(of: key) {
            order.remove(at: i)
            order.append(key)
        }
    }

    private func removeKey(_ key: Key) {
        map.removeValue(forKey: key)
        if let i = order.firstIndex(of: key) { order.remove(at: i) }
    }
}
