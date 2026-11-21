// P2: Two-level (memory + disk) cache API sketch
// Source: solutions/ch18/README.md

abstract class MemoryCache<K, V> {
  V? get(K key);
  void put(K key, V value);
  void remove(K key);
  void trimToHalf();
  void clear();
}

abstract class DiskCache<K, V> {
  V? get(K key);
  void put(K key, V value);
  void remove(K key);
}

enum TrimLevel { mild, critical }

class TwoLevelCache<K, V> {
  TwoLevelCache(this.memory, this.disk);
  final MemoryCache<K, V> memory;
  final DiskCache<K, V> disk;

  V? get(K key) {
    final m = memory.get(key);
    if (m != null) return m;
    final d = disk.get(key);
    if (d == null) return null;
    memory.put(key, d);
    return d;
  }

  void put(K key, V value) {
    memory.put(key, value);
    disk.put(key, value);
  }

  void trimMemory(TrimLevel level) {
    switch (level) {
      case TrimLevel.mild:
        memory.trimToHalf();
      case TrimLevel.critical:
        memory.clear();
    }
  }
}
