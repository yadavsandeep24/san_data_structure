// Q26. Merge K Sorted Lists (Feed Merge)
// Source: book/part-viii/29-interview-questions-q21-q30.md
package ch29.q26_merge_k_sorted_lists

import dsa.common.ListNode

fun mergeKLists(lists: Array<ListNode?>): ListNode? {
    val pq = java.util.PriorityQueue<ListNode>(compareBy { it.`val` })
    for (head in lists) if (head != null) pq.add(head)
    val dummy = ListNode(0)
    var tail = dummy
    while (pq.isNotEmpty()) {
        val n = pq.poll()
        tail.next = n; tail = n
        n.next?.let { pq.add(it) }
    }
    return dummy.next
}
