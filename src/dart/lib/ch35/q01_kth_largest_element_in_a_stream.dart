// Q1. Kth Largest Element in a Stream (Live Leaderboard Cutoff)
// Source: book/part-viii/35-heaps-tries-greedy.md
import 'dart:math';

class Heap<T> {
  final List<T> _items = [];
  final bool Function(T a, T b) _less;
  Heap(this._less);

  int get length => _items.length;
  T? get peek => _items.isEmpty ? null : _items.first;

  void push(T x) {
    _items.add(x);
    var i = _items.length - 1;
    while (i > 0) {
      final p = (i - 1) >> 1;
      if (!_less(_items[i], _items[p])) break;
      _swap(i, p);
      i = p;
    }
  }

  T? pop() {
    if (_items.isEmpty) return null;
    _swap(0, _items.length - 1);
    final top = _items.removeLast();
    var i = 0;
    while (true) {
      final l = 2 * i + 1, r = l + 1;
      var m = i;
      if (l < _items.length && _less(_items[l], _items[m])) m = l;
      if (r < _items.length && _less(_items[r], _items[m])) m = r;
      if (m == i) break;
      _swap(i, m);
      i = m;
    }
    return top;
  }

  void _swap(int i, int j) {
    final t = _items[i];
    _items[i] = _items[j];
    _items[j] = t;
  }
}

class KthLargest {
  final int k;
  final _heap = Heap<int>((a, b) => a < b); // min-heap of the top k

  KthLargest(this.k, List<int> nums) {
    for (final x in nums) {
      add(x);
    }
  }

  int add(int val) {
    _heap.push(val);
    if (_heap.length > k) _heap.pop();
    return _heap.peek ?? -1;
  }
}
