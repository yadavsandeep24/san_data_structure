// Producer-consumer and backpressure (network)
// Source: book/part-vii/28-concurrency.md

class BoundedBuffer<T> {
  private q: T[] = [];
  private putWaiters: Array<() => void> = [];
  private takeWaiters: Array<(x: T) => void> = [];
  private capacity: number;

  constructor(capacity: number) {
    if (capacity <= 0) throw new Error("capacity must be > 0");
    this.capacity = capacity;
  }

  async put(x: T): Promise<void> {
    while (this.q.length >= this.capacity) {
      await new Promise<void>((resolve) => this.putWaiters.push(resolve));
    }
    const taker = this.takeWaiters.shift();
    if (taker) taker(x);
    else this.q.push(x);
    this.resumePutWaiters();
  }

  take(): Promise<T> {
    if (this.q.length) {
      const x = this.q.shift() as T;
      this.resumePutWaiters();
      return Promise.resolve(x);
    }
    return new Promise<T>((resolve) => this.takeWaiters.push(resolve));
  }

  private resumePutWaiters(): void {
    while (this.q.length < this.capacity && this.putWaiters.length) {
      this.putWaiters.shift()?.();
    }
  }
}

export {};
