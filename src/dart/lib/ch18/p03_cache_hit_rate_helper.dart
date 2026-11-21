// P3: Cache hit-rate helper
// Source: solutions/ch18/README.md

class HitRateCounter {
  int hits = 0;
  int misses = 0;

  void recordHit() => hits++;
  void recordMiss() => misses++;

  double hitRate() {
    final t = hits + misses;
    return t == 0 ? 0.0 : hits / t;
  }
}
