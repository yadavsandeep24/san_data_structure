// Q25. Kth Largest Element
// Source: book/part-viii/29-interview-questions-q21-q30.md

// Min-heap via list for interview clarity

int findKthLargest(List<int> nums, int k) {
  final heap = <int>[];
  void swap(int a, int b) { final t = heap[a]; heap[a] = heap[b]; heap[b] = t; }
  void siftUp(int i) {
    while (i > 0) {
      final p = (i - 1) >> 1;
      if (heap[p] <= heap[i]) break;
      swap(p, i); i = p;
    }
  }
  void siftDown(int i) {
    while (true) {
      var s = i;
      final l = 2 * i + 1, r = l + 1;
      if (l < heap.length && heap[l] < heap[s]) s = l;
      if (r < heap.length && heap[r] < heap[s]) s = r;
      if (s == i) break;
      swap(i, s); i = s;
    }
  }
  for (final x in nums) {
    if (heap.length < k) { heap.add(x); siftUp(heap.length - 1); }
    else if (x > heap[0]) { heap[0] = x; siftDown(0); }
  }
  return heap[0];
}
