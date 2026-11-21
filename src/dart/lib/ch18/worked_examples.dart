// Worked examples (four languages)
// Source: book/part-v/18-caching-strategies.md

class LruCache<K, V> {
  LruCache(this.capacity);
  final int capacity;
  final _map = <K, V>{};
  final _order = <K>[]; // 0 = LRU

  V? get(K key) {
    final v = _map[key];
    if (v == null) return null;
    _touch(key);
    return v;
  }

  void put(K key, V value) {
    if (_map.containsKey(key)) {
      _map[key] = value;
      _touch(key);
      return;
    }
    if (_order.length >= capacity) {
      final evict = _order.removeAt(0);
      _map.remove(evict);
    }
    _map[key] = value;
    _order.add(key);
  }

  void _touch(K key) {
    _order.remove(key);
    _order.add(key);
  }
}

class Entry<V> {
  const Entry(this.value, this.expiresAtMillis);
  final V value;
  final int expiresAtMillis;
}

void example() {
  V? getIfFresh<V>(Map<String, Entry<V>> map, String key, int now) {
    final e = map[key];
    if (e == null) return null;
    if (now >= e.expiresAtMillis) return null; // treat as miss
    return e.value;
  }
}
