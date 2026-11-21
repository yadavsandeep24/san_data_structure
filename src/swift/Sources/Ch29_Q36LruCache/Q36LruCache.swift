// Q36. LRU Cache
// Source: book/part-viii/29-interview-questions-q31-q40.md

final class LRUCache {
    private final class Node {
        let key: Int; var value: Int
        var prev: Node?; var next: Node?
        init(_ key: Int, _ value: Int) { self.key = key; self.value = value }
    }
    private let capacity: Int
    private var map: [Int: Node] = [:]
    private let head = Node(0, 0), tail = Node(0, 0)
    init(_ capacity: Int) {
        self.capacity = capacity
        head.next = tail; tail.prev = head
    }
    private func remove(_ n: Node) { n.prev?.next = n.next; n.next?.prev = n.prev }
    private func addFront(_ n: Node) {
        n.next = head.next; n.prev = head
        head.next?.prev = n; head.next = n
    }
    func get(_ key: Int) -> Int {
        guard let n = map[key] else { return -1 }
        remove(n); addFront(n); return n.value
    }
    func put(_ key: Int, _ value: Int) {
        if let n = map[key] { remove(n); map.removeValue(forKey: key) }
        let n = Node(key, value); addFront(n); map[key] = n
        if map.count > capacity, let lru = tail.prev {
            remove(lru); map.removeValue(forKey: lru.key)
        }
    }
}
