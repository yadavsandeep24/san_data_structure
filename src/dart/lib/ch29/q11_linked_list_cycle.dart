// Q11. Linked List Cycle (Floyd)
// Source: book/part-viii/29-interview-questions-q11-q20.md
import '../common/nodes.dart';

bool hasCycle(ListNode? head) {
  var slow = head, fast = head;
  while (fast?.next != null) {
    slow = slow!.next;
    fast = fast!.next!.next;
    if (identical(slow, fast)) return true;
  }
  return false;
}
