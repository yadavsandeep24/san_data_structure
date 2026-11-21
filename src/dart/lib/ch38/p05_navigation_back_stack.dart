// P5. Navigation Back Stack
// Source: solutions/ch38/README.md

class NavStack {
  final _stack = <String>[];
  void push(String r) => _stack.add(r);
  String? pop() => _stack.isEmpty ? null : _stack.removeLast();
  String? peek() => _stack.isEmpty ? null : _stack.last;
  void replace(String r) {
    if (_stack.isEmpty) push(r); else _stack[_stack.length - 1] = r;
  }
  void popToRoot() { if (_stack.length > 1) _stack.removeRange(1, _stack.length); }
  List<String> snapshot() => List.of(_stack);
}
