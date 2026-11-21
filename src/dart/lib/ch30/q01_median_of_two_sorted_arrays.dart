// Q1. Median of Two Sorted Arrays (Fee Tier Cut)
// Source: book/part-viii/30-hard-drill-bank-q01-q10.md
import 'dart:math';

double findMedianSortedArrays(List<int> a, List<int> b) {
  if (a.length > b.length) return findMedianSortedArrays(b, a);
  final m = a.length, n = b.length;
  var lo = 0, hi = m;
  final half = (m + n + 1) ~/ 2;
  while (lo <= hi) {
    final i = (lo + hi) ~/ 2;
    final j = half - i;
    final num aLeft = i == 0 ? double.negativeInfinity : a[i - 1];
    final num aRight = i == m ? double.infinity : a[i];
    final num bLeft = j == 0 ? double.negativeInfinity : b[j - 1];
    final num bRight = j == n ? double.infinity : b[j];
    if (aLeft <= bRight && bLeft <= aRight) {
      if ((m + n) % 2 == 1) return max(aLeft, bLeft).toDouble();
      return (max(aLeft, bLeft) + min(aRight, bRight)) / 2.0;
    } else if (aLeft > bRight) {
      hi = i - 1;
    } else {
      lo = i + 1;
    }
  }
  throw StateError('unreachable');
}
