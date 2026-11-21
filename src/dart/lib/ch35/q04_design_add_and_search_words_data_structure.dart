// Q4. Design Add and Search Words Data Structure (Wildcard Contact Search)
// Source: book/part-viii/35-heaps-tries-greedy.md

class TrieNode {
  final next = <String, TrieNode>{};
  bool end = false;
}

class WordDictionary {
  final _root = TrieNode();

  void addWord(String word) {
    var cur = _root;
    for (final c in word.split('')) {
      cur = cur.next.putIfAbsent(c, () => TrieNode());
    }
    cur.end = true;
  }

  bool search(String word) {
    bool match(int i, TrieNode node) {
      if (i == word.length) return node.end;
      final c = word[i];
      if (c != '.') {
        final nx = node.next[c];
        return nx != null && match(i + 1, nx);
      }
      return node.next.values.any((child) => match(i + 1, child));
    }

    return match(0, _root);
  }
}
