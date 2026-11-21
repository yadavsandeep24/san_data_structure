// P3: Last stone weight
// Source: solutions/ch12/README.md

int lastStoneWeight(List<int> stones) {
  final h = <int>[];
  void siftUp(int i) {
    while (i > 0) {
      final p = (i - 1) ~/ 2;
      if (h[i] <= h[p]) break;
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
      if (l < h.length && h[l] > h[best]) best = l;
      if (r < h.length && h[r] > h[best]) best = r;
      if (best == i) break;
      final t = h[i];
      h[i] = h[best];
      h[best] = t;
      i = best;
    }
  }
  void push(int x) {
    h.add(x);
    siftUp(h.length - 1);
  }
  int pop() {
    final top = h.first;
    h[0] = h.removeLast();
    if (h.isNotEmpty) siftDown(0);
    return top;
  }
  for (final s in stones) {
    push(s);
  }
  while (h.length > 1) {
    final x = pop();
    final y = pop();
    if (x != y) push(x - y);
  }
  return h.isEmpty ? 0 : h.first;
}
