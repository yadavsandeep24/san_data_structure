// Worked examples (four languages)
// Source: book/part-ii/05-stacks.md

class Stack<E> {
  final _data = <E>[];
  void push(E x) => _data.add(x);
  E pop() => _data.removeLast();
  E get peek => _data.last;
  bool get isEmpty => _data.isEmpty;
}

bool isValid(String s) {
  final st = <String>[];
  const pair = {')': '(', ']': '[', '}': '{'};
  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    if ('([{'.contains(c)) {
      st.add(c);
    } else if (st.isEmpty || st.removeLast() != pair[c]) {
      return false;
    }
  }
  return st.isEmpty;
}

class MinStack {
  final _vals = <int>[];
  final _mins = <int>[];
  void push(int x) {
    _vals.add(x);
    _mins.add(_mins.isEmpty ? x : (x < _mins.last ? x : _mins.last));
  }
  void pop() { _vals.removeLast(); _mins.removeLast(); }
  int top() => _vals.last;
  int getMin() => _mins.last;
}
