// Q1 — Reorder list (Swift / Dart)
// Source: solutions/ch34/README.md
import '../common/nodes.dart';

void reorderList(ListNode? head) {
  if (head == null || head.next == null) return;
  var slow = head;
  ListNode? fast = head;
  while (fast?.next?.next != null) { // middle
    slow = slow.next!;
    fast = fast!.next!.next;
  }
  ListNode? prev, cur = slow.next;
  slow.next = null;
  while (cur != null) { // reverse 2nd half
    final nxt = cur.next;
    cur.next = prev;
    prev = cur;
    cur = nxt;
  }
  ListNode? a = head, b = prev;
  while (a != null && b != null) { // weave
    final aNext = a.next, bNext = b.next;
    a.next = b;
    b.next = aNext;
    a = aNext;
    b = bNext;
  }
}
