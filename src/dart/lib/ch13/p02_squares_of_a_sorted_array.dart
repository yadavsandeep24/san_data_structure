// P2: Squares of a sorted array
// Source: solutions/ch13/README.md

List<int> sortedSquares(List<int> a) {
  final out = List<int>.filled(a.length, 0);
  var lo = 0, hi = a.length - 1;
  for (var pos = a.length - 1; pos >= 0; pos--) {
    final l = a[lo] * a[lo], h = a[hi] * a[hi];
    if (l > h) {
      out[pos] = l;
      lo++;
    } else {
      out[pos] = h;
      hi--;
    }
  }
  return out;
}
