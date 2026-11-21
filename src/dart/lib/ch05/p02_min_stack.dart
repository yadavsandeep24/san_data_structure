// P2: Min stack
// Source: solutions/ch05/README.md

class MinStack {
  final _vals = <int>[];
  final _mins = <int>[];

  void push(int x) {
    _vals.add(x);
    _mins.add(_mins.isEmpty ? x : (x < _mins.last ? x : _mins.last));
  }

  void pop() {
    _vals.removeLast();
    _mins.removeLast();
  }

  int top() => _vals.last;
  int getMin() => _mins.last;
}
