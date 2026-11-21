// P1: Valid parentheses
// Source: solutions/ch05/README.md

bool isValid(String s) {
  final st = <String>[];
  const pair = {')': '(', ']': '[', '}': '{'};
  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    if (c == '(' || c == '[' || c == '{') {
      st.add(c);
    } else if (st.isEmpty || st.removeLast() != pair[c]) {
      return false;
    }
  }
  return st.isEmpty;
}
