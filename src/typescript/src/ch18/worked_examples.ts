// Worked examples (four languages)
// Source: book/part-v/18-caching-strategies.md

class LruCache<K, V> {
  private map = new Map<K, V>(); // Map preserves insertion order
  constructor(private capacity: number) {}

  get(key: K): V | undefined {
    if (!this.map.has(key)) return undefined;
    const v = this.map.get(key)!;
    this.map.delete(key);
    this.map.set(key, v); // move to newest
    return v;
  }

  put(key: K, value: V): void {
    if (this.map.has(key)) this.map.delete(key);
    this.map.set(key, value);
    if (this.map.size > this.capacity) {
      const lru = this.map.keys().next().value;
      if (lru !== undefined) this.map.delete(lru);
    }
  }
}

type Entry<V> = { value: V; expiresAtMillis: number };

function getIfFresh<V>(map: Map<string, Entry<V>>, key: string, now: number): V | undefined {
  const e = map.get(key);
  if (!e) return undefined;
  if (now >= e.expiresAtMillis) return undefined; // treat as miss
  return e.value;
}

export {};
