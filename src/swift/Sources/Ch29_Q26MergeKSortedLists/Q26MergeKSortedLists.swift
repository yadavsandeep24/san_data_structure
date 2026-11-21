// Q26. Merge K Sorted Lists (Feed Merge)
// Source: book/part-viii/29-interview-questions-q21-q30.md
import DSACommon

// No stdlib heap: pairwise divide-and-conquer, like the Dart/TS sketches
func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
    func merge(_ a: ListNode?, _ b: ListNode?) -> ListNode? {
        let d = ListNode(0)
        var t = d, p = a, q = b
        while let x = p, let y = q {
            if x.val <= y.val { t.next = x; p = x.next } else { t.next = y; q = y.next }
            t = t.next ?? t
        }
        t.next = p ?? q
        return d.next
    }
    if lists.isEmpty { return nil }
    var lists = lists
    var interval = 1
    while interval < lists.count {
        var i = 0
        while i + interval < lists.count {
            lists[i] = merge(lists[i], lists[i + interval])
            i += interval * 2
        }
        interval *= 2
    }
    return lists[0]
}
