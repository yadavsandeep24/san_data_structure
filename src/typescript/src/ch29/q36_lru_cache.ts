// Q36. LRU Cache
// Source: book/part-viii/29-interview-questions-q31-q40.md

class LNode {
  key: number; value: number;
  prev: LNode | null = null; next: LNode | null = null;
  constructor(key: number, value: number) { this.key = key; this.value = value; }
}
class LRUCache {
  private capacity: number;
  private map = new Map<number, LNode>();
  private head = new LNode(0, 0);
  private tail = new LNode(0, 0);
  constructor(capacity: number) {
    this.capacity = capacity;
    this.head.next = this.tail; this.tail.prev = this.head;
  }
  private remove(n: LNode): void { n.prev!.next = n.next; n.next!.prev = n.prev; }
  private addFront(n: LNode): void {
    n.next = this.head.next; n.prev = this.head;
    this.head.next!.prev = n; this.head.next = n;
  }
  get(key: number): number {
    const n = this.map.get(key);
    if (!n) return -1;
    this.remove(n); this.addFront(n); return n.value;
  }
  put(key: number, value: number): void {
    const old = this.map.get(key);
    if (old) { this.remove(old); this.map.delete(key); }
    const n = new LNode(key, value); this.addFront(n); this.map.set(key, n);
    if (this.map.size > this.capacity) {
      const lru = this.tail.prev!; this.remove(lru); this.map.delete(lru.key);
    }
  }
}

export {};
