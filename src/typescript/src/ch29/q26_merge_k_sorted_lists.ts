// Q26. Merge K Sorted Lists (Feed Merge)
// Source: book/part-viii/29-interview-questions-q21-q30.md
import { ListNode } from '../common/nodes';

function mergeKLists(lists: (ListNode | null)[]): ListNode | null {
  function merge(a: ListNode | null, b: ListNode | null): ListNode | null {
    const d = new ListNode(0); let t = d, p = a, q = b;
    while (p && q) {
      if (p.val <= q.val) { t.next = p; p = p.next; } else { t.next = q; q = q.next; }
      t = t.next!;
    }
    t.next = p ?? q; return d.next;
  }
  if (!lists.length) return null;
  let interval = 1;
  while (interval < lists.length) {
    for (let i = 0; i + interval < lists.length; i += interval * 2) {
      lists[i] = merge(lists[i], lists[i + interval]);
    }
    interval *= 2;
  }
  return lists[0];
}

export {};
