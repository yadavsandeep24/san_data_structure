// Worked example 3: middle of a linked list (fast/slow)
// Source: book/part-iv/13-two-pointers.md
package ch13.worked_example_3_middle_of_a_linked_list

class Node(val value: Int, var next: Node? = null)

fun middleNode(head: Node?): Node? {
    var slow = head
    var fast = head
    while (fast?.next != null) {
        slow = slow?.next
        fast = fast.next?.next
    }
    return slow // for even length, the second of the two middles
}
