// Q35. Implement Trie (Autocomplete Core)
// Source: book/part-viii/29-interview-questions-q31-q40.md

class _Node {
  final next = <String, _Node>{};
  var end = false;
}

class Trie {
  final _root = _Node();
  void insert(String word) {
    var n = _root;
    for (var i = 0; i < word.length; i++) {
      n = n.next.putIfAbsent(word[i], _Node.new);
    }
    n.end = true;
  }
  bool search(String word) => _walk(word)?.end ?? false;
  bool startsWith(String prefix) => _walk(prefix) != null;
  _Node? _walk(String s) {
    _Node? n = _root;
    for (var i = 0; i < s.length && n != null; i++) n = n.next[s[i]];
    return n;
  }
}
