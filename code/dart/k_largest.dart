// Sample: k largest values via size-k min-heap (Chapter 18)
List<int> kLargest(List<int> nums, int k) {
  final heap = <int>[];
  void siftUp(int i) {
    while (i > 0) {
      final p = (i - 1) >> 1;
      if (heap[i] >= heap[p]) break;
      final t = heap[i];
      heap[i] = heap[p];
      heap[p] = t;
      i = p;
    }
  }

  void siftDown(int i) {
    for (;;) {
      var best = i;
      final l = i * 2 + 1, r = l + 1;
      if (l < heap.length && heap[l] < heap[best]) best = l;
      if (r < heap.length && heap[r] < heap[best]) best = r;
      if (best == i) break;
      final t = heap[i];
      heap[i] = heap[best];
      heap[best] = t;
      i = best;
    }
  }

  for (final n in nums) {
    heap.add(n);
    siftUp(heap.length - 1);
    if (heap.length > k) {
      final last = heap.removeLast();
      if (heap.isNotEmpty) {
        heap[0] = last;
        siftDown(0);
      }
    }
  }
  final out = List<int>.of(heap)..sort((a, b) => b.compareTo(a));
  return out;
}
