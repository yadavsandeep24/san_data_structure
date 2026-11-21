// P3: Bounded request queue with drop policy
// Source: solutions/ch06/README.md
import { Queue } from './implementations';

type DropPolicy = 'dropNewest' | 'dropOldest';

interface Request { id: string; payload: Uint8Array }

class BoundedRequestQueue {
  private pending = new Queue<Request>();
  private inFlight = 0;

  constructor(
    private capacity: number,
    private maxInFlight: number,
    private policy: DropPolicy,
    private execute: (req: Request) => void,
  ) {}

  submit(req: Request): boolean {
    if (this.pending.size + this.inFlight >= this.capacity) {
      if (this.policy === 'dropNewest') return false;
      if (!this.pending.dequeue()) return false;
    }
    this.pending.enqueue(req);
    this.pump();
    return true;
  }

  onComplete(): void {
    this.inFlight = Math.max(0, this.inFlight - 1);
    this.pump();
  }

  private pump(): void {
    while (this.inFlight < this.maxInFlight && this.pending.size) {
      const next = this.pending.dequeue()!;
      this.inFlight++;
      this.execute(next);
    }
  }
}

export {};
