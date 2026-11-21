// LinkedHashMap and ordered maps
// Source: book/part-iii/07-hash-tables.md

// Default Map is insertion-ordered: remove + re-insert on access = access order

class LruSketch<K, V> {
  LruSketch(this.capacity);
  final int capacity;
  final _map = <K, V>{};
  V? get(K key) {
    if (!_map.containsKey(key)) return null;
    final v = _map.remove(key) as V;
    _map[key] = v; // move to most-recent end
    return v;
  }
  void put(K key, V value) {
    _map.remove(key);
    _map[key] = value;
    if (_map.length > capacity) _map.remove(_map.keys.first); // eldest
  }
}
