// Q38. Token Bucket Rate Limiter
// Source: book/part-viii/29-interview-questions-q31-q40.md
package ch29.q38_token_bucket_rate_limiter

class TokenBucket(private val rate: Double, private val capacity: Double) {
    private var tokens = capacity
    private var last = System.nanoTime()
    @Synchronized fun allow(): Boolean {
        val now = System.nanoTime()
        val elapsed = (now - last) / 1e9
        last = now
        tokens = minOf(capacity, tokens + elapsed * rate)
        if (tokens < 1.0) return false
        tokens -= 1.0
        return true
    }
}
