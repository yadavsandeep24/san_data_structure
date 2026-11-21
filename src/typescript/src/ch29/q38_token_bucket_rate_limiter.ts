// Q38. Token Bucket Rate Limiter
// Source: book/part-viii/29-interview-questions-q31-q40.md

// JS is single-threaded per realm: no lock needed
class TokenBucket {
  private rate: number;
  private capacity: number;
  private tokens: number;
  private last = performance.now();
  constructor(rate: number, capacity: number) {
    this.rate = rate; this.capacity = capacity; this.tokens = capacity;
  }
  allow(): boolean {
    const now = performance.now();
    const elapsed = (now - this.last) / 1000;
    this.last = now;
    this.tokens = Math.min(this.capacity, this.tokens + elapsed * this.rate);
    if (this.tokens < 1) return false;
    this.tokens -= 1;
    return true;
  }
}

export {};
