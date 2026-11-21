// P1. LRU Image Memory Cache
// Source: solutions/ch38/README.md

class ImageLruCache {
  private map = new Map<string, { key: string; bytes: Uint8Array; prev?: any; next?: any }>();
  private head: any = { key: "", bytes: new Uint8Array() };
  private tail: any = { key: "", bytes: new Uint8Array() };
  constructor(private capacity: number) {
    this.head.next = this.tail; this.tail.prev = this.head;
  }
  private remove(n: any) { n.prev.next = n.next; n.next.prev = n.prev; }
  private addFront(n: any) {
    n.next = this.head.next; n.prev = this.head;
    this.head.next.prev = n; this.head.next = n;
  }
  get(key: string): Uint8Array | undefined {
    const n = this.map.get(key); if (!n) return;
    this.remove(n); this.addFront(n); return n.bytes;
  }
  put(key: string, bytes: Uint8Array): void {
    if (this.map.has(key)) { this.remove(this.map.get(key)); this.map.delete(key); }
    const n = { key, bytes }; this.addFront(n); this.map.set(key, n as any);
    if (this.map.size > this.capacity) {
      const lru = this.tail.prev; this.remove(lru); this.map.delete(lru.key);
    }
  }
}

export {};
