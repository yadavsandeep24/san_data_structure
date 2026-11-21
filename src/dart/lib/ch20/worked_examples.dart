// Worked examples
// Source: book/part-v/20-decision-guide.md

class Cart {
  final _order = <String>[];
  final _qty = <String, int>{};

  void add(String sku) {
    final n = _qty[sku] ?? 0;
    if (n == 0) _order.add(sku);
    _qty[sku] = n + 1;
  }

  bool contains(String sku) => _qty.containsKey(sku);

  List<(String, int)> lines() =>
      [for (final s in _order) (s, _qty[s]!)];
}

class RecentSearches {
  RecentSearches(this.k);
  final int k;
  final _q = <String>[];
  var _head = 0;
  final _seen = <String>{};

  void add(String term) {
    if (_seen.contains(term)) {
      final i = _q.indexOf(term, _head);
      if (i >= 0) _q.removeAt(i);
    } else {
      _seen.add(term);
    }
    _q.add(term);
    while (_q.length - _head > k) {
      _seen.remove(_q[_head++]);
    }
  }

  List<String> list() => _q.sublist(_head).reversed.toList();
}
