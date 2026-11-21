// Q26. Merge K Sorted Lists (Feed Merge)
// Source: book/part-viii/29-interview-questions-q21-q30.md
import '../common/nodes.dart';

ListNode? mergeKLists(List<ListNode?> lists) {
  // simple pairwise merge for sketch without package heap:
  ListNode? merge(ListNode? a, ListNode? b) {
    final d = ListNode(0); var t = d;
    var p = a, q = b;
    while (p != null && q != null) {
      if (p.val <= q.val) { t.next = p; p = p.next; }
      else { t.next = q; q = q.next; }
      t = t.next!;
    }
    t.next = p ?? q;
    return d.next;
  }
  if (lists.isEmpty) return null;
  var interval = 1;
  while (interval < lists.length) {
    for (var i = 0; i + interval < lists.length; i += interval * 2) {
      lists[i] = merge(lists[i], lists[i + interval]);
    }
    interval *= 2;
  }
  return lists[0];
}
