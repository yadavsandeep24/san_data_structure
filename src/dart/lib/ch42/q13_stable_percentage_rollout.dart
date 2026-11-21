// Q13. Stable Percentage Rollout (New Signing Flow Flag)
// Source: book/part-ix/42-document-signing-drill-bank-q08-q13.md
import 'dart:convert';

int fnv1a(String s) {
  var h = 0x811C9DC5;
  for (final b in utf8.encode(s)) {
    h ^= b;
    // h * 0x01000193 mod 2^32 in 16-bit halves, so no step passes 2^53 (safe on Flutter web / JS).
    final lo = h & 0xFFFF, hi = h >> 16;
    final mid = (hi * 0x0193 + lo * 0x0100) & 0xFFFF;
    h = (lo * 0x0193 + mid * 0x10000) & 0xFFFFFFFF;
  }
  return h.toSigned(32); // same bits as the Kotlin Int
}

/// Bucket 0..9999 from flag key + user id: stable across sessions and devices, independent across flags.
int bucket(String flag, String userId) => fnv1a('$flag:$userId') % 10000; // Dart % is already floor-mod

bool isOn(String flag, String userId, double percent) => bucket(flag, userId) < (percent * 100).toInt();
