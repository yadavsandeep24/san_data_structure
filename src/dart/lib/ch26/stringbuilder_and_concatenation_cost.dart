// StringBuilder and concatenation cost
// Source: book/part-vii/26-strings.md

String joinCsv(List<String> parts) {
  final buf = StringBuffer();
  for (var i = 0; i < parts.length; i++) {
    if (i > 0) buf.write(',');
    buf.write(parts[i]);
  }
  return buf.toString();
}
