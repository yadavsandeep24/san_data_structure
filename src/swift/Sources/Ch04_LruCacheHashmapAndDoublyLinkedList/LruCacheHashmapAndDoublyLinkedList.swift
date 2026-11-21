// LRU cache: HashMap and doubly linked list
// Source: book/part-ii/04-linked-lists.md

final class LRUCache {
    private final class Node {
        let key: Int
        var value: Int
        var prev: Node?
        var next: Node?
        init(_ key: Int, _ value: Int) {
            self.key = key
            self.value = value
        }
    }

    private let capacity: Int
    private var map: [Int: Node] = [:]
    private let head = Node(-1, -1)
    private let tail = Node(-1, -1)

    init(_ capacity: Int) {
        self.capacity = capacity
        head.next = tail
        tail.prev = head
    }

    func get(_ key: Int) -> Int {
        guard let node = map[key] else { return -1 }
        moveToHead(node)
        return node.value
    }

    func put(_ key: Int, _ value: Int) {
        if let node = map[key] {
            node.value = value
            moveToHead(node)
            return
        }
        let node = Node(key, value)
        map[key] = node
        addAfterHead(node)
        if map.count > capacity {
            let lru = popTail()
            map[lru.key] = nil
        }
    }

    private func addAfterHead(_ node: Node) {
        node.prev = head
        node.next = head.next
        head.next?.prev = node
        head.next = node
    }

    private func remove(_ node: Node) {
        node.prev?.next = node.next
        node.next?.prev = node.prev
    }

    private func moveToHead(_ node: Node) {
        remove(node)
        addAfterHead(node)
    }

    private func popTail() -> Node {
        let node = tail.prev!
        remove(node)
        return node
    }
}
