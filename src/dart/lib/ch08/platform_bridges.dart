// Platform bridges
// Source: book/part-iii/08-sets.md
import 'dart:collection';

class SelectionTracker {
  final _selected = <String>{}; // LinkedHashSet: order = tap order

  void toggle(String id) {
    if (!_selected.add(id)) _selected.remove(id);
  }

  bool isSelected(String id) => _selected.contains(id);
  List<String> snapshot() => _selected.toList();
}
