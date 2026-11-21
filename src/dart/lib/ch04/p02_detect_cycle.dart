// P2: Detect cycle
// Source: solutions/ch04/README.md
import '../common/nodes.dart';

bool hasCycle(ListNode? head) {
  var slow = head;
  var fast = head;
  while (fast?.next != null) {
    slow = slow?.next;
    fast = fast!.next!.next;
    if (identical(slow, fast)) return true;
  }
  return false;
}

ListNode? detectCycle(ListNode? head) {
  var slow = head;
  var fast = head;
  while (fast?.next != null) {
    slow = slow?.next;
    fast = fast!.next!.next;
    if (identical(slow, fast)) {
      var p = head;
      while (!identical(p, slow)) {
        p = p?.next;
        slow = slow?.next;
      }
      return p;
    }
  }
  return null;
}
