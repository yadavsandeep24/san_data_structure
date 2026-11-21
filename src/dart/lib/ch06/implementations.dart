// Implementations (four languages)
// Source: book/part-ii/06-queues-deques.md
import 'dart:collection';

final q = Queue<String>();
void example() {
  q.addLast('a');
  q.addLast('b');
}
final front = q.removeFirst(); // a
