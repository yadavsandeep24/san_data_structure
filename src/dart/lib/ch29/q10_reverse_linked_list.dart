// Q10. Reverse Linked List
// Source: book/part-viii/29-interview-questions-q01-q10.md

class ListNode {
  int val; ListNode? next;
  ListNode(this.val, [this.next]);
}
ListNode? reverseList(ListNode? head) {
  ListNode? prev;
  var cur = head;
  while (cur != null) {
    final nxt = cur.next;
    cur.next = prev;
    prev = cur;
    cur = nxt;
  }
  return prev;
}
