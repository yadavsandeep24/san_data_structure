// Language realities
// Source: book/part-iii/12-heaps-priority-queues.md
import 'package:collection/collection.dart';

final pq = HeapPriorityQueue<int>();
void example() {
  pq.add(5); pq.add(1);
  pq.removeFirst(); // 1
}
