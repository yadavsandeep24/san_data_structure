// Q5 — Word Search II (Swift / Dart)
// Source: solutions/ch35/README.md

class WordNode {
  final next = <String, WordNode>{};
  String? word;
}

List<String> findWords(List<List<String>> board, List<String> words) {
  final root = WordNode();
  for (final w in words) {
    var cur = root;
    for (final c in w.split('')) {
      cur = cur.next.putIfAbsent(c, () => WordNode());
    }
    cur.word = w;
  }
  final rows = board.length, cols = board[0].length;
  final found = <String>[];
  void dfs(int r, int c, WordNode parent) {
    final ch = board[r][c];
    final node = parent.next[ch]; // '#' is never a trie edge
    if (node == null) return;
    final w = node.word;
    if (w != null) {
      found.add(w);
      node.word = null; // report once
    }
    board[r][c] = '#';
    if (r > 0) dfs(r - 1, c, node);
    if (r < rows - 1) dfs(r + 1, c, node);
    if (c > 0) dfs(r, c - 1, node);
    if (c < cols - 1) dfs(r, c + 1, node);
    board[r][c] = ch;
  }

  for (var r = 0; r < rows; r++) {
    for (var c = 0; c < cols; c++) {
      dfs(r, c, root);
    }
  }
  return found;
}
