// Q14: Find median from data stream (TypeScript two-heap or Swift or Dart)
// Source: solutions/ch30/README.md
import 'dart:math';

class MedianFinder {
  final _low = <int>[]; // max via sort desc
  final _high = <int>[];

  void addNum(int num) {
    _low.add(num);
    _low.sort((a, b) => b.compareTo(a));
    _high.add(_low.removeAt(0));
    _high.sort();
    if (_high.length > _low.length) {
      _low.add(_high.removeAt(0));
      _low.sort((a, b) => b.compareTo(a));
    }
  }

  double findMedian() {
    if (_low.length > _high.length) return _low.first.toDouble();
    return (_low.first + _high.first) / 2.0;
  }
}
