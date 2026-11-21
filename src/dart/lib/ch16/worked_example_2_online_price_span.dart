// Worked example 2: online price span (answer after popping)
// Source: book/part-iv/16-monotonic-stack-deque.md

class PriceSpan {
  final _prices = <int>[];
  final _spans = <int>[];
  int next(int price) {
    var span = 1;
    while (_prices.isNotEmpty && _prices.last <= price) {
      _prices.removeLast();
      span += _spans.removeLast();
    }
    _prices.add(price);
    _spans.add(span);
    return span;
  }
}
