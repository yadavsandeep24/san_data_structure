// Q9. LFU Cache
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md

class LFUCache {
  private cap: number;
  private keyNode = new Map<number, { value: number; freq: number }>();
  private freqList = new Map<number, Set<number>>(); // insertion order = LRU within freq
  private minFreq = 0;

  constructor(capacity: number) { this.cap = capacity; }

  get(key: number): number {
    const n = this.keyNode.get(key);
    if (!n) return -1;
    this.touch(key, n);
    return n.value;
  }

  put(key: number, value: number): void {
    if (this.cap === 0) return;
    const existing = this.keyNode.get(key);
    if (existing) {
      existing.value = value;
      this.touch(key, existing);
      return;
    }
    if (this.keyNode.size >= this.cap) {
      const set = this.freqList.get(this.minFreq)!;
      const evict = set.values().next().value as number;
      set.delete(evict);
      this.keyNode.delete(evict);
    }
    this.keyNode.set(key, { value, freq: 1 });
    if (!this.freqList.has(1)) this.freqList.set(1, new Set());
    this.freqList.get(1)!.add(key);
    this.minFreq = 1;
  }

  private touch(key: number, n: { value: number; freq: number }) {
    const f = n.freq;
    const set = this.freqList.get(f)!;
    set.delete(key);
    if (set.size === 0) {
      this.freqList.delete(f);
      if (this.minFreq === f) this.minFreq++;
    }
    n.freq = f + 1;
    if (!this.freqList.has(n.freq)) this.freqList.set(n.freq, new Set());
    this.freqList.get(n.freq)!.add(key);
  }
}

export {};
