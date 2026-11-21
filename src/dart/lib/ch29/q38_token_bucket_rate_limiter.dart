// Q38. Token Bucket Rate Limiter
// Source: book/part-viii/29-interview-questions-q31-q40.md
import 'dart:math' as math;

// One isolate = no shared-memory race, so no lock (unlike Kotlin/Swift)
import 'dart:math';

class TokenBucket {
  TokenBucket(this.rate, this.capacity) : _tokens = capacity;
  final double rate, capacity;
  double _tokens;
  final _clock = Stopwatch()..start();
  int _lastUs = 0;
  bool allow() {
    final now = _clock.elapsedMicroseconds;
    final elapsed = (now - _lastUs) / 1e6;
    _lastUs = now;
    _tokens = math.min(capacity, _tokens + elapsed * rate);
    if (_tokens < 1.0) return false;
    _tokens -= 1.0;
    return true;
  }
}
