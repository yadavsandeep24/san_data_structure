// Q3. Copy List with Random Pointer (Deep Copy a Linked Playlist)
// Source: book/part-viii/34-linked-lists-trees.md

final class Node {
    var val: Int
    var next: Node?
    var random: Node?
    init(_ val: Int) { self.val = val }
}

func copyRandomList(_ head: Node?) -> Node? {
    var copies: [ObjectIdentifier: Node] = [:] // keyed by original node identity
    var cur = head
    while let c = cur { // pass 1: clone every node
        copies[ObjectIdentifier(c)] = Node(c.val)
        cur = c.next
    }
    cur = head
    while let c = cur { // pass 2: wire next + random through the map
        let copy = copies[ObjectIdentifier(c)]
        copy?.next = c.next.flatMap { copies[ObjectIdentifier($0)] }
        copy?.random = c.random.flatMap { copies[ObjectIdentifier($0)] }
        cur = c.next
    }
    return head.flatMap { copies[ObjectIdentifier($0)] }
}
