// Q4. Add Two Numbers (Digit-List Amount Sum)
// Source: book/part-viii/34-linked-lists-trees.md
package ch34.q04_add_two_numbers

import dsa.common.ListNode

import ch34.shared_node_classes.*

fun addTwoNumbers(l1: ListNode?, l2: ListNode?): ListNode? {
    val dummy = ListNode(0)
    var tail = dummy
    var a = l1
    var b = l2
    var carry = 0
    while (a != null || b != null || carry != 0) {
        val sum = (a?.`val` ?: 0) + (b?.`val` ?: 0) + carry
        carry = sum / 10
        tail.next = ListNode(sum % 10)
        tail = tail.next!!
        a = a?.next
        b = b?.next
    }
    return dummy.next
}
