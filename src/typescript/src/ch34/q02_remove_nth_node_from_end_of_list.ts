// Q2. Remove Nth Node From End of List (Drop the Nth-Latest Notification)
// Source: book/part-viii/34-linked-lists-trees.md
import { ListNode } from '../common/nodes';

function removeNthFromEnd(head: ListNode | null, n: number): ListNode | null {
  const dummy = new ListNode(0, head);
  let lead: ListNode | null = dummy;
  for (let i = 0; i <= n; i++) lead = lead!.next; // open a gap of n nodes
  let trail: ListNode = dummy;
  while (lead) {
    lead = lead.next;
    trail = trail.next!;
  }
  trail.next = trail.next!.next; // trail sits just before the target
  return dummy.next;
}

export {};
