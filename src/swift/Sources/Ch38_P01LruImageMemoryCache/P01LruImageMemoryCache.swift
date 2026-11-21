// P1. LRU Image Memory Cache
// Source: solutions/ch38/README.md
import Foundation

final class ImageLruCache {
    private final class Node {
        let key: String; var bytes: Data
        var prev: Node?; var next: Node?
        init(_ key: String, _ bytes: Data) { self.key = key; self.bytes = bytes }
    }
    private let capacity: Int
    private var map: [String: Node] = [:]
    private let head = Node("", Data()), tail = Node("", Data())
    init(_ capacity: Int) {
        self.capacity = capacity
        head.next = tail; tail.prev = head
    }
    private func remove(_ n: Node) { n.prev?.next = n.next; n.next?.prev = n.prev }
    private func addFront(_ n: Node) {
        n.next = head.next; n.prev = head
        head.next?.prev = n; head.next = n
    }
    func get(_ key: String) -> Data? {
        guard let n = map[key] else { return nil }
        remove(n); addFront(n); return n.bytes
    }
    func put(_ key: String, _ bytes: Data) {
        if let n = map[key] { remove(n); map.removeValue(forKey: key) }
        let n = Node(key, bytes); addFront(n); map[key] = n
        if map.count > capacity, let lru = tail.prev {
            remove(lru); map.removeValue(forKey: lru.key)
        }
    }
}
