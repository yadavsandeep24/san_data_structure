// Q1. Reorder List (Interleave Oldest and Newest)
// Source: book/part-viii/34-linked-lists-trees.md
import { ListNode } from '../common/nodes';

function reorderList(head: ListNode | null): void {
  if (!head || !head.next) return;
  // 1. Find the middle (slow ends at the end of the first half).
  let slow: ListNode = head;
  let fast: ListNode | null = head;
  while (fast && fast.next && fast.next.next) {
    slow = slow.next!;
    fast = fast.next.next;
  }
  // 2. Reverse the second half.
  let prev: ListNode | null = null;
  let cur = slow.next;
  slow.next = null;
  while (cur) {
    const nxt: ListNode | null = cur.next;
    cur.next = prev;
    prev = cur;
    cur = nxt;
  }
  // 3. Weave: first, last, second, second-last, ...
  let a: ListNode | null = head;
  let b: ListNode | null = prev;
  while (a && b) {
    const aNext: ListNode | null = a.next;
    const bNext: ListNode | null = b.next;
    a.next = b;
    b.next = aNext;
    a = aNext;
    b = bNext;
  }
}

export {};
