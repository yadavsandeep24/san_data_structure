// Worked building blocks (four languages)
// Source: book/part-ii/04-linked-lists.md
package ch04.worked_building_blocks

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
