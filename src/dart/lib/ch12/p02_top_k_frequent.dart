// P2: Top K frequent
// Source: solutions/ch12/README.md

List<int> topKFrequent(List<int> nums, int k) {
  final freq = <int, int>{};
  for (final x in nums) {
    freq[x] = (freq[x] ?? 0) + 1;
  }
  final h = <List<int>>[]; // [freq, value]
  void siftUp(int i) {
    while (i > 0) {
      final p = (i - 1) ~/ 2;
      if (h[i][0] >= h[p][0]) break;
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
      if (l < h.length && h[l][0] < h[best][0]) best = l;
      if (r < h.length && h[r][0] < h[best][0]) best = r;
      if (best == i) break;
      final t = h[i];
      h[i] = h[best];
      h[best] = t;
      i = best;
    }
  }
  freq.forEach((v, f) {
    h.add([f, v]);
    siftUp(h.length - 1);
    if (h.length > k) {
      h[0] = h.removeLast();
      if (h.isNotEmpty) siftDown(0);
    }
  });
  return h.map((e) => e[1]).toList();
}
