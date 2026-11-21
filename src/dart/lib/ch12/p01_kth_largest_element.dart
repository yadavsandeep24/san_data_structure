// P1: Kth largest element
// Source: solutions/ch12/README.md
import 'package:collection/collection.dart';

int findKthLargest(List<int> nums, int k) {
  final pq = HeapPriorityQueue<int>();
  for (final x in nums) {
    pq.add(x);
    if (pq.length > k) pq.removeFirst();
  }
  return pq.first;
}

int findKthLargestManual(List<int> nums, int k) {
  final h = <int>[];
  void siftUp(int i) {
    while (i > 0) {
      final p = (i - 1) ~/ 2;
      if (h[i] >= h[p]) break;
      final t = h[i];
      h[i] = h[p];
      h[p] = t;
      i = p;
    }
  }
  void siftDown(int i) {
    for (;;) {
      var best = i;
      final l = 2 * i + 1, r = l + 1;
      if (l < h.length && h[l] < h[best]) best = l;
      if (r < h.length && h[r] < h[best]) best = r;
      if (best == i) break;
      final t = h[i];
      h[i] = h[best];
      h[best] = t;
      i = best;
    }
  }
  for (final x in nums) {
    h.add(x);
    siftUp(h.length - 1);
    if (h.length > k) {
      h[0] = h.removeLast();
      if (h.isNotEmpty) siftDown(0);
    }
  }
  return h.first;
}
