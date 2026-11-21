// P2: Contiguous array (equal 0s and 1s)
// Source: solutions/ch15/README.md

int findMaxLength(List<int> a) {
  final first = <int, int>{0: -1};
  var prefix = 0, best = 0;
  for (var i = 0; i < a.length; i++) {
    prefix += a[i] == 1 ? 1 : -1;
    final f = first[prefix];
    if (f != null) {
      if (i - f > best) best = i - f;
    } else {
      first[prefix] = i;
    }
  }
  return best;
}
