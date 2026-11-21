// P1: Find pivot index
// Source: solutions/ch15/README.md

int pivotIndex(List<int> a) {
  final total = a.fold<int>(0, (s, x) => s + x);
  var left = 0;
  for (var i = 0; i < a.length; i++) {
    if (left == total - left - a[i]) return i;
    left += a[i];
  }
  return -1;
}
