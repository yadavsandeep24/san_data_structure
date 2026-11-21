// P2: Bounded blocking queue or async channel
// Source: solutions/ch28/README.md

class BoundedAsyncQueue<T> {
  private q: T[] = [];
  private putWaiters: Array<() => void> = [];
  private takeWaiters: Array<(v: T) => void> = [];

  constructor(private capacity: number) {
    if (capacity <= 0) throw new Error("capacity");
  }

  async put(value: T): Promise<void> {
    while (this.q.length >= this.capacity && this.takeWaiters.length === 0) {
      await new Promise<void>((r) => this.putWaiters.push(r));
    }
    const taker = this.takeWaiters.shift();
    if (taker) taker(value);
    else this.q.push(value);
    this.drainPutWaiters();
  }

  async take(): Promise<T> {
    if (this.q.length) {
      const v = this.q.shift()!;
      this.drainPutWaiters();
      return v;
    }
    return new Promise<T>((r) => this.takeWaiters.push(r));
  }

  private drainPutWaiters() {
    while (this.q.length < this.capacity && this.putWaiters.length) {
      this.putWaiters.shift()!();
    }
  }
}

export {};
