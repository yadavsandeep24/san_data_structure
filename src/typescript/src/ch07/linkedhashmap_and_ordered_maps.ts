// LinkedHashMap and ordered maps
// Source: book/part-iii/07-hash-tables.md

// Map iterates in insertion order: delete + set on access = access order
class LruSketch<K, V> {
  private map = new Map<K, V>();
  private capacity: number;
  constructor(capacity: number) { this.capacity = capacity; }
  get(key: K): V | undefined {
    if (!this.map.has(key)) return undefined;
    const v = this.map.get(key) as V;
    this.map.delete(key);
    this.map.set(key, v); // move to most-recent end
    return v;
  }
  put(key: K, value: V): void {
    this.map.delete(key);
    this.map.set(key, value);
    if (this.map.size > this.capacity) {
      const eldest = this.map.keys().next().value as K;
      this.map.delete(eldest);
    }
  }
}

export {};
