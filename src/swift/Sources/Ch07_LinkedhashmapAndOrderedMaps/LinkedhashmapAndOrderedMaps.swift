// LinkedHashMap and ordered maps
// Source: book/part-iii/07-hash-tables.md

// Sketch: Dictionary has no access order — keep keys in recency order
// (O(n) reorder here; Chapter 18's map + linked list makes it O(1))
final class LruSketch<K: Hashable, V> {
    private let capacity: Int
    private var map: [K: V] = [:]
    private var order: [K] = []           // least recent first
    init(_ capacity: Int) { self.capacity = capacity }
    func get(_ key: K) -> V? {
        guard let v = map[key] else { return nil }
        touch(key)
        return v
    }
    func put(_ key: K, _ value: V) {
        map[key] = value
        touch(key)
        if map.count > capacity {
            let eldest = order.removeFirst()
            map.removeValue(forKey: eldest)
        }
    }
    private func touch(_ key: K) {
        if let i = order.firstIndex(of: key) { order.remove(at: i) }
        order.append(key)
    }
}
