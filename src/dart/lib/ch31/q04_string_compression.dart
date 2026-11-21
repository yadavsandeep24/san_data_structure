// Q4. String Compression (Run-Length Log Packing)
// Source: book/part-viii/31-arrays-hashing-matrix.md

int compress(List<String> chars) {
  var write = 0;
  var read = 0;
  while (read < chars.length) {
    final ch = chars[read];
    var run = 0;
    while (read < chars.length && chars[read] == ch) {
      read++;
      run++;
    }
    chars[write++] = ch;
    if (run > 1) {
      for (final d in run.toString().split('')) {
        chars[write++] = d;
      }
    }
  }
  return write;
}
