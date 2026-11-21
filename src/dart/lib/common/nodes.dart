/// Shared node types for list and tree problems.
/// Supports both `.value` and `.val` field names used across the book.
class ListNode {
  int value;
  ListNode? next;
  ListNode(this.value, [this.next]);
  int get val => value;
  set val(int v) => value = v;
}

class TreeNode {
  int value;
  TreeNode? left;
  TreeNode? right;
  TreeNode(this.value, [this.left, this.right]);
  int get val => value;
  set val(int v) => value = v;
}
