// Q4. Integer Square Root without Floating Point (Thumbnail Grid)
// Source: book/part-viii/37-math-and-number-drills.md

int isqrt(int x) {
  if (x < 0) throw ArgumentError('negative');
  var lo = 0;
  var hi = x < 3037000499 ? x : 3037000499;          // largest r whose square fits in 64 bits
  while (lo < hi) {
    final mid = lo + (hi - lo + 1) ~/ 2;             // round up so the loop always shrinks
    if (mid <= x ~/ mid) {
      lo = mid;                                      // mid * mid <= x, without overflow
    } else {
      hi = mid - 1;
    }
  }
  return lo;
}
