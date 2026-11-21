// Q12. Justify Text for a Narrow Screen (Agreement Preview)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md

List<String> justify(List<String> words, int width) {
  final lines = <String>[];
  var i = 0;
  while (i < words.length) {
    var j = i, len = 0;
    while (j < words.length && len + words[j].length + (j - i) <= width) { len += words[j].length; j++; }
    if (j == i) throw ArgumentError('word longer than width: ${words[i]}');
    final gaps = j - i - 1;
    if (j == words.length || gaps == 0) {
      lines.add(words.sublist(i, j).join(' ').padRight(width)); // last line or one word: left-aligned
    } else {
      final spaces = width - len, each = spaces ~/ gaps, extra = spaces % gaps;
      final sb = StringBuffer();
      for (var k = i; k < j; k++) {
        sb.write(words[k]);
        if (k < j - 1) sb.write(' ' * (each + (k - i < extra ? 1 : 0)));
      }
      lines.add(sb.toString());
    }
    i = j;
  }
  return lines;
}
