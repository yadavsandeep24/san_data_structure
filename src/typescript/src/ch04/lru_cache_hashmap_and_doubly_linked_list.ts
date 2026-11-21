// LRU cache: HashMap and doubly linked list
// Source: book/part-ii/04-linked-lists.md

export class LRUCache {
  private capacity: number;
  private map = new Map<number, Node>();
  private head = new Node(-1, -1);
  private tail = new Node(-1, -1);

  constructor(capacity: number) {
    this.capacity = capacity;
    this.head.next = this.tail;
    this.tail.prev = this.head;
  }

  get(key: number): number {
    const node = this.map.get(key);
    if (!node) return -1;
    this.moveToHead(node);
    return node.value;
  }

  put(key: number, value: number): void {
    const existing = this.map.get(key);
    if (existing) {
      existing.value = value;
      this.moveToHead(existing);
      return;
    }
    const node = new Node(key, value);
    this.map.set(key, node);
    this.addAfterHead(node);
    if (this.map.size > this.capacity) {
      const lru = this.popTail();
      this.map.delete(lru.key);
    }
  }

  private addAfterHead(node: Node): void {
    node.prev = this.head;
    node.next = this.head.next;
    this.head.next!.prev = node;
    this.head.next = node;
  }

  private remove(node: Node): void {
    node.prev!.next = node.next;
    node.next!.prev = node.prev;
  }

  private moveToHead(node: Node): void {
    this.remove(node);
    this.addAfterHead(node);
  }

  private popTail(): Node {
    const node = this.tail.prev!;
    this.remove(node);
    return node;
  }
}

class Node {
  prev: Node | null = null;
  next: Node | null = null;
  constructor(public key: number, public value: number) {}
}

export {};
