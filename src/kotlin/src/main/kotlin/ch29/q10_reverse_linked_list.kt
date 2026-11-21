// Q10. Reverse Linked List
// Source: book/part-viii/29-interview-questions-q01-q10.md
package ch29.q10_reverse_linked_list

class ListNode(var `val`: Int, var next: ListNode? = null)
fun reverseList(head: ListNode?): ListNode? {
    var prev: ListNode? = null
    var cur = head
    while (cur != null) {
        val nxt = cur.next
        cur.next = prev
        prev = cur
        cur = nxt
    }
    return prev
}
