// P1: Move zeroes
// Source: solutions/ch13/README.md

void moveZeroes(List<int> a) {
  var write = 0;
  for (var read = 0; read < a.length; read++) {
    if (a[read] != 0) a[write++] = a[read];
  }
  while (write < a.length) {
    a[write++] = 0;
  }
}
