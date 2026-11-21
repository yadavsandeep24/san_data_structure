// P3: Cache hit-rate helper
// Source: solutions/ch18/README.md

class HitRateCounter {
  hits = 0;
  misses = 0;

  recordHit(): void {
    this.hits++;
  }
  recordMiss(): void {
    this.misses++;
  }
  hitRate(): number {
    const t = this.hits + this.misses;
    return t === 0 ? 0 : this.hits / t;
  }
}

export {};
