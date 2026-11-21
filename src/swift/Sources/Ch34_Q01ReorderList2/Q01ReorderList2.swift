// Q1 — Reorder list (Swift / Dart)
// Source: solutions/ch34/README.md
import DSACommon

func reorderList(_ head: ListNode?) {
    guard let head = head, head.next != nil else { return }
    var slow = head, fast: ListNode? = head
    while let f = fast?.next?.next { slow = slow.next!; fast = f } // middle
    var prev: ListNode? = nil, cur = slow.next
    slow.next = nil
    while let c = cur { let nxt = c.next; c.next = prev; prev = c; cur = nxt } // reverse 2nd half
    var a: ListNode? = head, b = prev
    while let x = a, let y = b { // weave
        let xNext = x.next, yNext = y.next
        x.next = y; y.next = xNext
        a = xNext; b = yNext
    }
}
