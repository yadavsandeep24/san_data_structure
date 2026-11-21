// P1: TTL + LRU hybrid cache
// Source: solutions/ch18/README.md

type Entry<V> = { value: V; expiresAt: number };

class TtlLruCache<K, V> {
  private map = new Map<K, Entry<V>>();
  constructor(
    private capacity: number,
    private clock: () => number = () => Date.now(),
  ) {
    this.capacity = Math.max(1, capacity);
  }

  get(key: K): V | undefined {
    const e = this.map.get(key);
    if (!e) return undefined;
    if (this.clock() >= e.expiresAt) {
      this.map.delete(key);
      return undefined;
    }
    this.map.delete(key);
    this.map.set(key, e);
    return e.value;
  }

  put(key: K, value: V, ttlMs: number): void {
    if (this.map.has(key)) this.map.delete(key);
    this.map.set(key, { value, expiresAt: this.clock() + ttlMs });
    while (this.map.size > this.capacity) {
      const lru = this.map.keys().next().value;
      if (lru === undefined) break;
      this.map.delete(lru);
    }
  }
}

export {};
