// Q12. Merge Two Sorted Lists
// Source: book/part-viii/29-interview-questions-q11-q20.md
package ch29.q12_merge_two_sorted_lists

import dsa.common.ListNode

fun mergeTwoLists(a: ListNode?, b: ListNode?): ListNode? {
    val dummy = ListNode(0)
    var t = dummy
    var p = a; var q = b
    while (p != null && q != null) {
        if (p.`val` <= q.`val`) { t.next = p; p = p.next }
        else { t.next = q; q = q.next }
        t = t.next!!
    }
    t.next = p ?: q
    return dummy.next
}
