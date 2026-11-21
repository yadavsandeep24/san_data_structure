// P2: Detect cycle
// Source: solutions/ch04/README.md
package ch04.p02_detect_cycle

import dsa.common.ListNode

fun hasCycle(head: ListNode?): Boolean {
    var slow = head
    var fast = head
    while (fast?.next != null) {
        slow = slow?.next
        fast = fast.next?.next
        if (slow === fast) return true
    }
    return false
}

fun detectCycle(head: ListNode?): ListNode? {
    var slow = head
    var fast = head
    while (fast?.next != null) {
        slow = slow?.next
        fast = fast.next?.next
        if (slow === fast) {
            var p = head
            while (p !== slow) {
                p = p?.next
                slow = slow?.next
            }
            return p
        }
    }
    return null
}
