// Q11. Linked List Cycle (Floyd)
// Source: book/part-viii/29-interview-questions-q11-q20.md
import { ListNode } from '../common/nodes';

function hasCycle(head: ListNode | null): boolean {
  let slow = head, fast = head;
  while (fast?.next) {
    slow = slow!.next;
    fast = fast.next.next;
    if (slow === fast) return true;
  }
  return false;
}

export {};
