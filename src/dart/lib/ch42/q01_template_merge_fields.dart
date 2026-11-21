// Q1. Template Merge Fields (Envelope Email Body)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

String render(
  String t,
  Map<String, String> values, {
  String Function(String key)? onMissing,
}) {
  final missing = onMissing ?? (k) => '{{$k}}';
  final sb = StringBuffer();
  var i = 0;
  while (i < t.length) {
    if (t.startsWith(r'\{{', i)) {
      sb.write('{{');
      i += 3;
    } else if (t.startsWith('{{', i)) {
      final end = t.indexOf('}}', i + 2);
      if (end == -1) throw FormatException('Unclosed field at index $i');
      final key = t.substring(i + 2, end).trim();
      sb.write(values[key] ?? missing(key));
      i = end + 2;
    } else {
      sb.write(t[i]);
      i++;
    }
  }
  return sb.toString();
}
