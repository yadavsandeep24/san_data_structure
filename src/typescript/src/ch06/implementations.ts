// Implementations (four languages)
// Source: book/part-ii/06-queues-deques.md

export class Queue<T> {
  private data: T[] = [];
  private head = 0;

  enqueue(x: T): void { this.data.push(x); }

  dequeue(): T | undefined {
    if (this.head >= this.data.length) return undefined;
    const v = this.data[this.head++];
    if (this.head > 32 && this.head * 2 >= this.data.length) {
      this.data = this.data.slice(this.head);
      this.head = 0;
    }
    return v;
  }

  peek(): T | undefined {
    return this.head < this.data.length ? this.data[this.head] : undefined;
  }

  get size(): number { return this.data.length - this.head; }
}

export {};
