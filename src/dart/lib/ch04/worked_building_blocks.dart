// Worked building blocks (four languages)
// Source: book/part-ii/04-linked-lists.md

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

bool hasCycle(ListNode? head) {
  var slow = head, fast = head;
  while (fast?.next != null) {
    slow = slow?.next;
    fast = fast!.next!.next;
    if (identical(slow, fast)) return true;
  }
  return false;
}
