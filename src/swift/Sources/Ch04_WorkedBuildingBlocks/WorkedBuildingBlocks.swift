// Worked building blocks (four languages)
// Source: book/part-ii/04-linked-lists.md

final class ListNode {
    var value: Int
    var next: ListNode?
    init(_ value: Int, _ next: ListNode? = nil) {
        self.value = value
        self.next = next
    }
}

func reverseList(_ head: ListNode?) -> ListNode? {
    var prev: ListNode? = nil
    var curr = head
    while let node = curr {
        let nxt = node.next
        node.next = prev
        prev = node
        curr = nxt
    }
    return prev
}

func hasCycle(_ head: ListNode?) -> Bool {
    var slow = head, fast = head
    while let f = fast?.next {
        slow = slow?.next
        fast = f.next
        if slow === fast { return true }
    }
    return false
}
