// P3: Flatten nested map keys
// Source: solutions/ch10/README.md

Map<String, Object?> flatten(Object? node, [String prefix = '']) {
  final out = <String, Object?>{};
  void walk(Object? n, String path) {
    if (n is Map) {
      if (n.isEmpty && path.isNotEmpty) out[path] = n;
      n.forEach((k, v) {
        final next = path.isEmpty ? '$k' : '$path.$k';
        walk(v, next);
      });
    } else if (n is List) {
      if (n.isEmpty && path.isNotEmpty) out[path] = n;
      for (var i = 0; i < n.length; i++) {
        walk(n[i], '$path[$i]');
      }
    } else {
      out[path] = n;
    }
  }
  walk(node, prefix);
  return out;
}
