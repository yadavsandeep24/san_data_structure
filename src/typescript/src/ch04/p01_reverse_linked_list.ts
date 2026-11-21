// P1: Reverse linked list
// Source: solutions/ch04/README.md

class ListNode {
  constructor(public value: number, public next: ListNode | null = null) {}
}

function reverseList(head: ListNode | null): ListNode | null {
  let prev: ListNode | null = null;
  let curr = head;
  while (curr) {
    const nxt = curr.next;
    curr.next = prev;
    prev = curr;
    curr = nxt;
  }
  return prev;
}

function reverseListRecursive(head: ListNode | null): ListNode | null {
  if (!head?.next) return head;
  const newHead = reverseListRecursive(head.next);
  head.next.next = head;
  head.next = null;
  return newHead;
}

export {};
