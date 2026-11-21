// Q3. Copy List with Random Pointer (Deep Copy a Linked Playlist)
// Source: book/part-viii/34-linked-lists-trees.md

class Node {
  int val;
  Node? next;
  Node? random;
  Node(this.val);
}

Node? copyRandomList(Node? head) {
  final copies = Map<Node, Node>.identity();
  for (var cur = head; cur != null; cur = cur.next) {
    copies[cur] = Node(cur.val); // pass 1: clone every node
  }
  for (var cur = head; cur != null; cur = cur.next) { // pass 2: wire next + random
    final copy = copies[cur]!;
    copy.next = cur.next == null ? null : copies[cur.next!];
    copy.random = cur.random == null ? null : copies[cur.random!];
  }
  return head == null ? null : copies[head];
}
