// P3: Phone letter combinations
// Source: solutions/ch22/README.md

List<String> letterCombinations(String digits) {
  if (digits.isEmpty) return [];
  const map = ['', '', 'abc', 'def', 'ghi', 'jkl', 'mno', 'pqrs', 'tuv', 'wxyz'];
  final out = <String>[];
  final path = <String>[];
  void dfs(int i) {
    if (i == digits.length) {
      out.add(path.join());
      return;
    }
    final letters = map[digits.codeUnitAt(i) - 48];
    for (var k = 0; k < letters.length; k++) {
      path.add(letters[k]);
      dfs(i + 1);
      path.removeLast();
    }
  }
  dfs(0);
  return out;
}
