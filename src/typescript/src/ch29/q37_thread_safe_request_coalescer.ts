// Q37. Thread-Safe Request Coalescer (Single-Flight)
// Source: book/part-viii/29-interview-questions-q31-q40.md

class Coalescer<T> {
  private inflight = new Map<string, Promise<T>>();
  load(key: string, produce: () => Promise<T>): Promise<T> {
    const existing = this.inflight.get(key);
    if (existing) return existing;
    const p = produce().finally(() => this.inflight.delete(key));
    this.inflight.set(key, p);
    return p;
  }
}

export {};
