// P3: Cache hit-rate helper
// Source: solutions/ch18/README.md
package ch18.p03_cache_hit_rate_helper

class HitRateCounter {
    var hits: Long = 0
        private set
    var misses: Long = 0
        private set

    fun recordHit() { hits++ }
    fun recordMiss() { misses++ }

    fun hitRate(): Double {
        val t = hits + misses
        return if (t == 0L) 0.0 else hits.toDouble() / t
    }

    fun reset() {
        hits = 0
        misses = 0
    }
}

// usage inside cache get:
// val v = map[key]; if (v == null) { counter.recordMiss(); return null } else { counter.recordHit(); return v }
