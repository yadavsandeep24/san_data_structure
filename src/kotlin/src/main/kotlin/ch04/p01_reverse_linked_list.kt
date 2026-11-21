// P1: Reverse linked list
// Source: solutions/ch04/README.md
package ch04.p01_reverse_linked_list

class ListNode(var value: Int, var next: ListNode? = null)

fun reverseList(head: ListNode?): ListNode? {
    var prev: ListNode? = null
    var curr = head
    while (curr != null) {
        val nxt = curr.next
        curr.next = prev
        prev = curr
        curr = nxt
    }
    return prev
}

fun reverseListRecursive(head: ListNode?): ListNode? {
    if (head?.next == null) return head
    val newHead = reverseListRecursive(head.next)
    head.next!!.next = head
    head.next = null
    return newHead
}
