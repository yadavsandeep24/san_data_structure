// Q2. K Closest Points to Origin (Nearest Stores on the Map)
// Source: book/part-viii/35-heaps-tries-greedy.md

// uses Heap<T> from Q1
import 'dart:math';
import 'q01_kth_largest_element_in_a_stream.dart' show Heap;

List<List<int>> kClosest(List<List<int>> points, int k) {
  int dist(List<int> p) => p[0] * p[0] + p[1] * p[1];
  final heap = Heap<List<int>>((a, b) => dist(a) > dist(b)); // max-heap by distance
  for (final p in points) {
    heap.push(p);
    if (heap.length > k) heap.pop(); // drop the farthest
  }
  final out = <List<int>>[];
  for (var p = heap.pop(); p != null; p = heap.pop()) {
    out.add(p);
  }
  return out;
}
