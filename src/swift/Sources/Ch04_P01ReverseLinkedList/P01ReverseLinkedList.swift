// P1: Reverse linked list
// Source: solutions/ch04/README.md

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

func reverseListRecursive(_ head: ListNode?) -> ListNode? {
    guard let head = head, head.next != nil else { return head }
    let newHead = reverseListRecursive(head.next)
    head.next?.next = head
    head.next = nil
    return newHead
}
