// Q10. Reverse Linked List
// Source: book/part-viii/29-interview-questions-q01-q10.md

class ListNode {
  val: number; next: ListNode | null;
  constructor(val = 0, next: ListNode | null = null) { this.val = val; this.next = next; }
}
function reverseList(head: ListNode | null): ListNode | null {
  let prev: ListNode | null = null, cur = head;
  while (cur) {
    const nxt = cur.next; cur.next = prev; prev = cur; cur = nxt;
  }
  return prev;
}

export {};
