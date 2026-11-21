// P1: Reverse linked list
// Source: solutions/ch04/README.md

class ListNode {
  int value;
  ListNode? next;
  ListNode(this.value, [this.next]);
}

ListNode? reverseList(ListNode? head) {
  ListNode? prev;
  var curr = head;
  while (curr != null) {
    final nxt = curr.next;
    curr.next = prev;
    prev = curr;
    curr = nxt;
  }
  return prev;
}

ListNode? reverseListRecursive(ListNode? head) {
  if (head == null || head.next == null) return head;
  final newHead = reverseListRecursive(head.next);
  head.next!.next = head;
  head.next = null;
  return newHead;
}
