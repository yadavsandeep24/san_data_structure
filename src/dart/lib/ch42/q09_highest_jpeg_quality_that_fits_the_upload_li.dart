// Q9. Highest JPEG Quality That Fits the Upload Limit (Binary Search on the Answer)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md

/// size(q) must not decrease as q rises. Largest q in [lo, hi] with size(q) <= limit, or null.

int? bestQuality(int lo, int hi, int limit, int Function(int q) size) {
  var l = lo, h = hi;
  int? best;
  while (l <= h) {
    final mid = l + (h - l) ~/ 2;
    if (size(mid) <= limit) {
      best = mid;
      l = mid + 1;
    } else {
      h = mid - 1;
    }
  }
  return best;
}
