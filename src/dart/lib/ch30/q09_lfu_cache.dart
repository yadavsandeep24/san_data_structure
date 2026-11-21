// Q9. LFU Cache
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md
import 'dart:collection';

class LFUCache {
  LFUCache(this.capacity);
  final int capacity;
  final _keyNode = <int, (int value, int freq)>{};
  final _freqList = <int, Set<int>>{}; // LinkedHashSet: insertion order = LRU first
  var _minFreq = 0;

  int get(int key) {
    final n = _keyNode[key];
    if (n == null) return -1;
    _touch(key, n);
    return n.$1;
  }

  void put(int key, int value) {
    if (capacity == 0) return;
    final existing = _keyNode[key];
    if (existing != null) {
      _keyNode[key] = (value, existing.$2);
      _touch(key, (value, existing.$2));
      return;
    }
    if (_keyNode.length >= capacity) {
      final set = _freqList[_minFreq]!;
      final evict = set.first;
      set.remove(evict);
      _keyNode.remove(evict);
    }
    _keyNode[key] = (value, 1);
    (_freqList[1] ??= {}).add(key);
    _minFreq = 1;
  }

  void _touch(int key, (int, int) n) {
    final f = n.$2;
    _freqList[f]!.remove(key);
    if (_freqList[f]!.isEmpty) {
      _freqList.remove(f);
      if (_minFreq == f) _minFreq++;
    }
    final nf = f + 1;
    _keyNode[key] = (n.$1, nf);
    (_freqList[nf] ??= {}).add(key);
  }
}
