// Tries for autocomplete
// Source: book/part-iii/10-trees-practical.md

class _TrieNode {
  final children = <String, _TrieNode>{};
  var end = false;
}

class Trie {
  final _root = _TrieNode();

  void insert(String word) {
    var n = _root;
    for (final ch in word.split('')) {
      n = n.children.putIfAbsent(ch, _TrieNode.new);
    }
    n.end = true;
  }

  bool search(String word) => _walk(word)?.end == true;

  bool startsWith(String prefix) => _walk(prefix) != null;

  _TrieNode? _walk(String s) {
    var n = _root;
    for (final ch in s.split('')) {
      final next = n.children[ch];
      if (next == null) return null;
      n = next;
    }
    return n;
  }
}
