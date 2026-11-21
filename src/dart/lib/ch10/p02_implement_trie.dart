// P2: Implement Trie
// Source: solutions/ch10/README.md

class Trie {
  final _root = _Node();

  void insert(String word) {
    var n = _root;
    for (final r in word.runes) {
      final c = String.fromCharCode(r);
      n = n.children.putIfAbsent(c, () => _Node());
    }
    n.end = true;
  }

  bool search(String word) => _walk(word)?.end == true;

  bool startsWith(String prefix) => _walk(prefix) != null;

  _Node? _walk(String s) {
    var n = _root;
    for (final r in s.runes) {
      final c = String.fromCharCode(r);
      final next = n.children[c];
      if (next == null) return null;
      n = next;
    }
    return n;
  }
}

class _Node {
  final children = <String, _Node>{};
  bool end = false;
}
