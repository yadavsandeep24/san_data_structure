// Q6. Valid Parentheses (Schema or Deep Link Path)
// Source: book/part-viii/29-interview-questions-q01-q10.md

bool isValid(String s) {
  final st = <String>[];
  const pair = {')': '(', ']': '[', '}': '{'};
  for (final r in s.runes) {
    final c = String.fromCharCode(r);
    if ('([{'.contains(c)) st.add(c);
    else if (st.isEmpty || st.removeLast() != pair[c]) return false;
  }
  return st.isEmpty;
}
