// Q4. Add Two Numbers (Digit-List Amount Sum)
// Source: book/part-viii/34-linked-lists-trees.md
import DSACommon

func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    let dummy = ListNode(0)
    var tail = dummy
    var a = l1, b = l2
    var carry = 0
    while a != nil || b != nil || carry != 0 {
        let sum = (a?.val ?? 0) + (b?.val ?? 0) + carry
        carry = sum / 10
        let node = ListNode(sum % 10)
        tail.next = node
        tail = node
        a = a?.next
        b = b?.next
    }
    return dummy.next
}
