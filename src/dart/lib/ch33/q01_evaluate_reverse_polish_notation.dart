// Q1. Evaluate Reverse Polish Notation (Calculator Keypad Engine)
// Source: book/part-viii/33-stacks-binary-search.md

int evalRPN(List<String> tokens) {
  final stack = <int>[];
  for (final t in tokens) {
    if (t == '+' || t == '-' || t == '*' || t == '/') {
      final b = stack.removeLast();
      final a = stack.removeLast();
      switch (t) {
        case '+':
          stack.add(a + b);
        case '-':
          stack.add(a - b);
        case '*':
          stack.add(a * b);
        default:
          stack.add(a ~/ b); // ~/ truncates toward zero
      }
    } else {
      stack.add(int.parse(t));
    }
  }
  return stack.removeLast();
}
