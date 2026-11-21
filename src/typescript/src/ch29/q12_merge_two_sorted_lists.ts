// Q12. Merge Two Sorted Lists
// Source: book/part-viii/29-interview-questions-q11-q20.md
import { ListNode } from '../common/nodes';

function mergeTwoLists(a: ListNode | null, b: ListNode | null): ListNode | null {
  const dummy = new ListNode(0);
  let t = dummy, p = a, q = b;
  while (p && q) {
    if (p.val <= q.val) { t.next = p; p = p.next; }
    else { t.next = q; q = q.next; }
    t = t.next!;
  }
  t.next = p ?? q;
  return dummy.next;
}

export {};
