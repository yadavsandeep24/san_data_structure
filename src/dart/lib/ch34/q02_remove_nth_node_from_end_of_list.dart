// Q2. Remove Nth Node From End of List (Drop the Nth-Latest Notification)
// Source: book/part-viii/34-linked-lists-trees.md
import '../common/nodes.dart';

ListNode? removeNthFromEnd(ListNode? head, int n) {
  final dummy = ListNode(0, head);
  ListNode? lead = dummy;
  for (var i = 0; i <= n; i++) lead = lead?.next; // open a gap of n nodes
  var trail = dummy;
  while (lead != null) {
    lead = lead.next;
    trail = trail.next!;
  }
  trail.next = trail.next?.next; // trail sits just before the target
  return dummy.next;
}
