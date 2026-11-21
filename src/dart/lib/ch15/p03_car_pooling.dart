// P3: Car pooling (capacity check)
// Source: solutions/ch15/README.md

bool carPooling(List<List<int>> trips, int capacity) {
  final diff = List<int>.filled(1001, 0);
  for (final t in trips) {
    diff[t[1]] += t[0];
    diff[t[2]] -= t[0];
  }
  var onBoard = 0;
  for (final d in diff) {
    onBoard += d;
    if (onBoard > capacity) return false;
  }
  return true;
}
