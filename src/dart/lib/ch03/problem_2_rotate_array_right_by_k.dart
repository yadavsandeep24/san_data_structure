// Problem 2 — Rotate array right by k
// Source: solutions/ch03/README.md

void rotateRightInPlace(List<int> a, int kRaw) {
  final n = a.length;
  if (n == 0) return;
  var k = kRaw % n;
  if (k < 0) k += n;
  if (k == 0) return;

  void reverse(int from, int to) {
    // [from, to)
    var i = from;
    var j = to - 1;
    while (i < j) {
      final tmp = a[i];
      a[i] = a[j];
      a[j] = tmp;
      i++;
      j--;
    }
  }

  reverse(0, n);
  reverse(0, k);
  reverse(k, n);
}

// final a = [1, 2, 3, 4, 5]; rotateRightInPlace(a, 2); // [4, 5, 1, 2, 3]
