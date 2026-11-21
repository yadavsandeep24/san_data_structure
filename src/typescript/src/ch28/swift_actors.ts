// Swift actors
// Source: book/part-vii/28-concurrency.md
import { SerialQueue } from './serial_queues';

// No `actor` keyword: route every method through the SerialQueue above.
class SafeCounter {
  private q = new SerialQueue();
  private value = 0;
  increment(): Promise<void> {
    return this.q.enqueue(() => { this.value++; });
  }
  get(): Promise<number> {
    return this.q.enqueue(() => this.value);
  }
}

export {};
