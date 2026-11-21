// Q2. Remove Nth Node From End of List (Drop the Nth-Latest Notification)
// Source: book/part-viii/34-linked-lists-trees.md
package ch34.q02_remove_nth_node_from_end_of_list

import dsa.common.ListNode

import ch34.shared_node_classes.*

fun removeNthFromEnd(head: ListNode?, n: Int): ListNode? {
    val dummy = ListNode(0, head)
    var lead: ListNode? = dummy
    repeat(n + 1) { lead = lead?.next } // open a gap of n nodes
    var trail: ListNode = dummy
    while (lead != null) {
        lead = lead?.next
        trail = trail.next!!
    }
    trail.next = trail.next?.next // trail sits just before the target
    return dummy.next
}
