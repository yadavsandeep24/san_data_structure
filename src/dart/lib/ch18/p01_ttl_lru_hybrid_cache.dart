// P1: TTL + LRU hybrid cache
// Source: solutions/ch18/README.md

class TtlLruCache<K, V> {
  TtlLruCache(this.capacity, {int Function()? clock})
      : _clock = clock ?? (() => DateTime.now().millisecondsSinceEpoch);

  final int capacity;
  final int Function() _clock;
  final _map = <K, _Entry<V>>{};
  final _order = <K>[];

  V? get(K key) {
    final e = _map[key];
    if (e == null) return null;
    if (_clock() >= e.expiresAt) {
      _remove(key);
      return null;
    }
    _touch(key);
    return e.value;
  }

  void put(K key, V value, int ttlMillis) {
    final exp = _clock() + ttlMillis;
    if (_map.containsKey(key)) {
      _map[key] = _Entry(value, exp);
      _touch(key);
      return;
    }
    while (_order.length >= capacity) {
      _remove(_order.first);
    }
    _map[key] = _Entry(value, exp);
    _order.add(key);
  }

  void _touch(K key) {
    _order.remove(key);
    _order.add(key);
  }

  void _remove(K key) {
    _map.remove(key);
    _order.remove(key);
  }
}

class _Entry<V> {
  _Entry(this.value, this.expiresAt);
  final V value;
  final int expiresAt;
}
