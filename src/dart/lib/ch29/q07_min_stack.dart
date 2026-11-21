// Q7. Min Stack (Debug Overlay)
// Source: book/part-viii/29-interview-questions-q01-q10.md

class MinStack {
  final _st = <List<int>>[];
  void push(int x) {
    final m = _st.isEmpty ? x : (x < _st.last[1] ? x : _st.last[1]);
    _st.add([x, m]);
  }
  void pop() => _st.removeLast();
  int top() => _st.last[0];
  int getMin() => _st.last[1];
}
