// Q19. Design Hit Counter (Rate Limit Window)
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md
import 'dart:collection';

class HitCounter {
  final _q = Queue<int>();
  void hit(int timestamp) => _q.add(timestamp);
  int getHits(int timestamp) {
    while (_q.isNotEmpty && _q.first <= timestamp - 300) {
      _q.removeFirst();
    }
    return _q.length;
  }
}
