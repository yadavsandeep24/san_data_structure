// P1. LRU Image Memory Cache
// Source: solutions/ch38/README.md

class ImageLruCache {
  ImageLruCache(this.capacity);
  final int capacity;
  final _map = <String, _Node>{};
  final _head = _Node('', []);
  final _tail = _Node('', []);
  // wire head↔tail in constructor body if using late init pattern
  void _ensure() {
    _head.next ??= _tail;
    _tail.prev ??= _head;
  }
  List<int>? get(String key) {
    _ensure();
    final n = _map[key];
    if (n == null) return null;
    _remove(n); _addFront(n);
    return n.bytes;
  }
  void put(String key, List<int> bytes) {
    _ensure();
    final old = _map.remove(key);
    if (old != null) _remove(old);
    final n = _Node(key, bytes);
    _addFront(n); _map[key] = n;
    if (_map.length > capacity) {
      final lru = _tail.prev!;
      _remove(lru); _map.remove(lru.key);
    }
  }
  void _remove(_Node n) { n.prev!.next = n.next; n.next!.prev = n.prev; }
  void _addFront(_Node n) {
    n.next = _head.next; n.prev = _head;
    _head.next!.prev = n; _head.next = n;
  }
}
class _Node {
  _Node(this.key, this.bytes);
  final String key; List<int> bytes;
  _Node? prev, next;
}
