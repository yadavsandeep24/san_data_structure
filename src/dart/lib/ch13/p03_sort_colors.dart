// P3: Sort colors (three-way partition)
// Source: solutions/ch13/README.md

void sortColors(List<int> a) {
  var low = 0, mid = 0, high = a.length - 1;
  void swap(int i, int j) {
    final t = a[i];
    a[i] = a[j];
    a[j] = t;
  }

  while (mid <= high) {
    if (a[mid] == 0) {
      swap(low++, mid++);
    } else if (a[mid] == 1) {
      mid++;
    } else {
      swap(mid, high--);
    }
  }
}
