// Q3. Copy List with Random Pointer (Deep Copy a Linked Playlist)
// Source: book/part-viii/34-linked-lists-trees.md

class Node {
  val: number;
  next: Node | null = null;
  random: Node | null = null;
  constructor(val: number) { this.val = val; }
}

function copyRandomList(head: Node | null): Node | null {
  const copies = new Map<Node, Node>();
  for (let cur = head; cur; cur = cur.next) copies.set(cur, new Node(cur.val)); // pass 1: clone
  for (let cur = head; cur; cur = cur.next) { // pass 2: wire next + random through the map
    const copy = copies.get(cur)!;
    copy.next = cur.next ? copies.get(cur.next)! : null;
    copy.random = cur.random ? copies.get(cur.random)! : null;
  }
  return head ? copies.get(head)! : null;
}

export {};
