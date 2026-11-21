// Q10. Reverse Linked List
// Source: book/part-viii/29-interview-questions-q01-q10.md

class ListNode {
    var val: Int
    var next: ListNode?
    init(_ val: Int, _ next: ListNode? = nil) { self.val = val; self.next = next }
}
func reverseList(_ head: ListNode?) -> ListNode? {
    var prev: ListNode? = nil, cur = head
    while let c = cur {
        let nxt = c.next; c.next = prev; prev = c; cur = nxt
    }
    return prev
}
