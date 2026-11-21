// P2. Autocomplete Trie
// Source: solutions/ch38/README.md

class AutoComplete {
  final _root = _TNode();
  void insert(String word) {
    var n = _root;
    for (final r in word.toLowerCase().runes) {
      final c = String.fromCharCode(r);
      n = n.kids.putIfAbsent(c, () => _TNode());
    }
    n.end = true;
  }
  List<String> suggest(String prefix, int k) {
    var n = _root;
    final p = prefix.toLowerCase();
    for (final r in p.runes) {
      final c = String.fromCharCode(r);
      final next = n.kids[c];
      if (next == null) return [];
      n = next;
    }
    final out = <String>[];
    void dfs(_TNode cur, String path) {
      if (out.length >= k) return;
      if (cur.end) out.add(path);
      for (final e in cur.kids.entries) {
        dfs(e.value, path + e.key);         // StringBuffer has no length setter; pass the prefix down
        if (out.length >= k) return;
      }
    }
    dfs(n, p);
    return out;
  }
}
class _TNode {
  final kids = <String, _TNode>{};
  bool end = false;
}
