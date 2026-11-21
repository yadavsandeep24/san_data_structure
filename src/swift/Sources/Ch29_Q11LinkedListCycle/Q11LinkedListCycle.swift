// Q11. Linked List Cycle (Floyd)
// Source: book/part-viii/29-interview-questions-q11-q20.md
import DSACommon

func hasCycle(_ head: ListNode?) -> Bool {
    var slow = head, fast = head
    while let f = fast?.next {
        slow = slow?.next
        fast = f.next
        if slow === fast { return true }
    }
    return false
}
