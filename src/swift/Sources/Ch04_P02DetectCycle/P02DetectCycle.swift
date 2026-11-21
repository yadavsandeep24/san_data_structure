// P2: Detect cycle
// Source: solutions/ch04/README.md
import DSACommon

func hasCycle(_ head: ListNode?) -> Bool {
    var slow = head
    var fast = head
    while let f = fast?.next {
        slow = slow?.next
        fast = f.next
        if slow === fast { return true }
    }
    return false
}

func detectCycle(_ head: ListNode?) -> ListNode? {
    var slow = head
    var fast = head
    while let f = fast?.next {
        slow = slow?.next
        fast = f.next
        if slow === fast {
            var p = head
            while p !== slow {
                p = p?.next
                slow = slow?.next
            }
            return p
        }
    }
    return nil
}
