// P1: Queue with two stacks
// Source: solutions/ch06/README.md

class MyQueue {
  final _inbound = <int>[];
  final _outbound = <int>[];

  void push(int x) => _inbound.add(x);

  int pop() {
    _move();
    return _outbound.removeLast();
  }

  int peek() {
    _move();
    return _outbound.last;
  }

  bool empty() => _inbound.isEmpty && _outbound.isEmpty;

  void _move() {
    if (_outbound.isEmpty) {
      while (_inbound.isNotEmpty) {
        _outbound.add(_inbound.removeLast());
      }
    }
  }
}
