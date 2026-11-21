// Q2. Remove Nth Node From End of List (Drop the Nth-Latest Notification)
// Source: book/part-viii/34-linked-lists-trees.md
import DSACommon

func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
    let dummy = ListNode(0, head)
    var lead: ListNode? = dummy
    for _ in 0...n { lead = lead?.next } // open a gap of n nodes
    var trail = dummy
    while lead != nil {
        lead = lead?.next
        guard let nxt = trail.next else { break }
        trail = nxt
    }
    trail.next = trail.next?.next // trail sits just before the target
    return dummy.next
}
