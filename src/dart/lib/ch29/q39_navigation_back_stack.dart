// Q39. Navigation Back Stack
// Source: book/part-viii/29-interview-questions-q31-q40.md

class NavStack {
  final _stack = <String>[];
  void push(String route) => _stack.add(route);
  String? pop() => _stack.isEmpty ? null : _stack.removeLast();
  String? peek() => _stack.isEmpty ? null : _stack.last;
  void replace(String route) {
    if (_stack.isEmpty) _stack.add(route); else _stack[_stack.length - 1] = route;
  }
  void popToRoot() { if (_stack.isNotEmpty) _stack.removeRange(1, _stack.length); }
  List<String> snapshot() => List.of(_stack);
}
