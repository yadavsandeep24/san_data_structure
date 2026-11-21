// P3: Simplify absolute path
// Source: solutions/ch05/README.md

String simplifyPath(String path) {
  final st = <String>[];
  for (final part in path.split('/')) {
    if (part.isEmpty || part == '.') continue;
    if (part == '..') {
      if (st.isNotEmpty) st.removeLast();
    } else {
      st.add(part);
    }
  }
  return '/${st.join('/')}';
}
