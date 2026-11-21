// Q10 — Deep-link router (Swift / Dart)
// Source: solutions/ch42/README.md

class _Node<T> {
  final kids = <String, _Node<T>>{};
  (String, _Node<T>)? param;
  T? wildcard;
  T? value;
}

class Router<T> {
  final _root = _Node<T>();

  static List<String> _segments(String s) =>
      s.split('?').first.split('/').where((p) => p.isNotEmpty).toList();

  void add(String pattern, T value) {
    var n = _root;
    for (final seg in _segments(pattern)) {
      if (seg == '*') { n.wildcard = value; return; }
      if (seg.startsWith(':')) {
        n.param ??= (seg.substring(1), _Node<T>());
        n = n.param!.$2;
      } else {
        n = n.kids.putIfAbsent(seg, () => _Node<T>());
      }
    }
    n.value = value;
  }

  /// Static segments beat :params, which beat *. Backtracks if a static branch dead-ends.
  (T, Map<String, String>)? match(String path) {
    final segs = _segments(path);
    (T, Map<String, String>)? go(_Node<T> n, int i, Map<String, String> params) {
      if (i == segs.length) {
        final v = n.value ?? n.wildcard;
        return v == null ? null : (v, params);
      }
      final k = n.kids[segs[i]];
      if (k != null) {
        final m = go(k, i + 1, params);
        if (m != null) return m;
      }
      final p = n.param;
      if (p != null) {
        final m = go(p.$2, i + 1, {...params, p.$1: segs[i]});
        if (m != null) return m;
      }
      final w = n.wildcard;
      return w == null ? null : (w, params);
    }
    return go(_root, 0, const {});
  }
}
