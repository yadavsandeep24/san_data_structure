// Q12. Merge Two Sorted Lists
// Source: book/part-viii/29-interview-questions-q11-q20.md
import DSACommon

func mergeTwoLists(_ a: ListNode?, _ b: ListNode?) -> ListNode? {
    let dummy = ListNode(0); var t = dummy
    var p = a, q = b
    while let x = p, let y = q {
        if x.val <= y.val { t.next = x; p = x.next }
        else { t.next = y; q = y.next }
        t = t.next!
    }
    t.next = p ?? q
    return dummy.next
}
