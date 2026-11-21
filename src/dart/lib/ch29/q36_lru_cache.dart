// Q36. LRU Cache
// Source: book/part-viii/29-interview-questions-q31-q40.md

class _Node {
  _Node(this.key, this.value);
  final int key;
  int value;
  _Node? prev, next;
}

class LRUCache {
  LRUCache(this.capacity) { head.next = tail; tail.prev = head; }
  final int capacity;
  final _map = <int, _Node>{};
  final head = _Node(0, 0), tail = _Node(0, 0);
  void _remove(_Node n) { n.prev!.next = n.next; n.next!.prev = n.prev; }
  void _addFront(_Node n) {
    n.next = head.next; n.prev = head;
    head.next!.prev = n; head.next = n;
  }
  int get(int key) {
    final n = _map[key];
    if (n == null) return -1;
    _remove(n); _addFront(n); return n.value;
  }
  void put(int key, int value) {
    final old = _map.remove(key);
    if (old != null) _remove(old);
    final n = _Node(key, value); _addFront(n); _map[key] = n;
    if (_map.length > capacity) {
      final lru = tail.prev!; _remove(lru); _map.remove(lru.key);
    }
  }
}
