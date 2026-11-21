// Q4. Add Two Numbers (Digit-List Amount Sum)
// Source: book/part-viii/34-linked-lists-trees.md
import '../common/nodes.dart';

ListNode? addTwoNumbers(ListNode? l1, ListNode? l2) {
  final dummy = ListNode(0);
  var tail = dummy;
  var a = l1, b = l2;
  var carry = 0;
  while (a != null || b != null || carry != 0) {
    final sum = (a?.val ?? 0) + (b?.val ?? 0) + carry;
    carry = sum ~/ 10;
    final node = ListNode(sum % 10);
    tail.next = node;
    tail = node;
    a = a?.next;
    b = b?.next;
  }
  return dummy.next;
}
