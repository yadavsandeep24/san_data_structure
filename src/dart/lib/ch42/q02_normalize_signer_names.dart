// Q2. Normalize Signer Names (Duplicate Recipients)
// Source: book/part-ix/42-document-signing-drill-bank-q01-q07.md

// Dart core has no Unicode normalization; fold common Latin accents by table.
// For full NFD use package:unorm_dart.

const _accents = 'ÀÁÂÃÄÅàáâãäåÈÉÊËèéêëÌÍÎÏìíîïÒÓÔÕÖòóôõöÙÚÛÜùúûüÑñÇçÝýÿ';
const _plain = 'AAAAAAaaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUUuuuuNnCcYyy';

String _fold(String s) {
  final sb = StringBuffer();
  for (final ch in s.split('')) {
    final i = _accents.indexOf(ch);
    sb.write(i == -1 ? ch : _plain[i]); // José -> Jose
  }
  return sb.toString();
}

final _separators = RegExp(r'[\s,]+');

String canonical(String name) {
  final tokens = _fold(name).toLowerCase().split(_separators).where((t) => t.isNotEmpty).toList()
    ..sort(); // "Doe, Jane" == "Jane Doe"
  return tokens.join(' ');
}

List<List<String>> duplicateGroups(List<String> names) {
  final groups = <String, List<String>>{}; // insertion-ordered
  for (final n in names) {
    groups.putIfAbsent(canonical(n), () => []).add(n);
  }
  return groups.values.where((g) => g.length > 1).toList();
}
