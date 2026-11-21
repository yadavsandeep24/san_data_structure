// Q1. Reorder List (Interleave Oldest and Newest)
// Source: book/part-viii/34-linked-lists-trees.md
package ch34.q01_reorder_list

import dsa.common.ListNode

import ch34.shared_node_classes.*

fun reorderList(head: ListNode?) {
    if (head?.next == null) return
    // 1. Find the middle (slow ends at the end of the first half).
    var slow: ListNode = head
    var fast: ListNode? = head
    while (fast?.next?.next != null) {
        slow = slow.next!!
        fast = fast.next!!.next
    }
    // 2. Reverse the second half.
    var prev: ListNode? = null
    var cur = slow.next
    slow.next = null
    while (cur != null) {
        val nxt = cur.next
        cur.next = prev
        prev = cur
        cur = nxt
    }
    // 3. Weave: first, last, second, second-last, ...
    var a: ListNode? = head
    var b = prev
    while (a != null && b != null) {
        val aNext = a.next
        val bNext = b.next
        a.next = b
        b.next = aNext
        a = aNext
        b = bNext
    }
}
