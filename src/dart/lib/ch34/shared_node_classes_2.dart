// Shared node classes (Swift / Dart)
// Source: solutions/ch34/README.md

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
