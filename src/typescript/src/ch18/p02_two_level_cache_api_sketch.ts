// P2: Two-level (memory + disk) cache API sketch
// Source: solutions/ch18/README.md

interface MemoryCache<K, V> {
  get(key: K): V | undefined;
  put(key: K, value: V): void;
  remove(key: K): void;
  trimToHalf(): void;
  clear(): void;
}

interface DiskCache<K, V> {
  get(key: K): V | undefined;
  put(key: K, value: V): void;
  remove(key: K): void;
}

type TrimLevel = "mild" | "critical";

class TwoLevelCache<K, V> {
  constructor(
    private memory: MemoryCache<K, V>,
    private disk: DiskCache<K, V>,
  ) {}

  get(key: K): V | undefined {
    const m = this.memory.get(key);
    if (m !== undefined) return m;
    const d = this.disk.get(key);
    if (d === undefined) return undefined;
    this.memory.put(key, d);
    return d;
  }

  put(key: K, value: V): void {
    this.memory.put(key, value);
    this.disk.put(key, value);
  }

  trimMemory(level: TrimLevel): void {
    if (level === "mild") this.memory.trimToHalf();
    else this.memory.clear();
  }
}

export {};
