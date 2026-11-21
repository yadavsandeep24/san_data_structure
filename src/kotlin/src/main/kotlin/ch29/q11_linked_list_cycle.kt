// Q11. Linked List Cycle (Floyd)
// Source: book/part-viii/29-interview-questions-q11-q20.md
package ch29.q11_linked_list_cycle

import dsa.common.ListNode

fun hasCycle(head: ListNode?): Boolean {
    var slow = head
    var fast = head
    while (fast?.next != null) {
        slow = slow!!.next
        fast = fast.next!!.next
        if (slow === fast) return true
    }
    return false
}
