// P6. Thread-Safe Request Coalescer
// Source: solutions/ch38/README.md
import { T } from './p04_task_scheduler';

class Coalescer<T> {
  private inflight = new Map<string, Promise<T>>();
  load(key: string, produce: () => Promise<T>): Promise<T> {
    const hit = this.inflight.get(key);
    if (hit) return hit;
    const p = produce().finally(() => this.inflight.delete(key));
    this.inflight.set(key, p);
    return p;
  }
}

export {};
