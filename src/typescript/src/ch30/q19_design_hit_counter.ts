// Q19. Design Hit Counter (Rate Limit Window)
// Source: book/part-viii/30-hard-drill-bank-q11-q20.md

class HitCounter {
  private q: number[] = [];
  hit(timestamp: number): void { this.q.push(timestamp); }
  getHits(timestamp: number): number {
    while (this.q.length && this.q[0] <= timestamp - 300) this.q.shift();
    return this.q.length;
  }
}

export {};
