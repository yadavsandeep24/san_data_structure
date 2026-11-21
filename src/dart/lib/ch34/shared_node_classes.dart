// Shared node classes
// Source: book/part-viii/34-linked-lists-trees.md

class ListNode {
  int val;
  ListNode? next;
  ListNode(this.val, [this.next]);
}

class TreeNode {
  int val;
  TreeNode? left;
  TreeNode? right;
  TreeNode(this.val);
}
