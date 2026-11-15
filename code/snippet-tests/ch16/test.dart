
import 'dart:math';
void eq(Object? a, Object? b, String m) { if (a.toString() != b.toString()) throw Exception('$m got $a want $b'); }
void main() {
  final r = Random(9);
  for (var t = 0; t < 400; t++) {
    final n = 1 + r.nextInt(10); final a = List.generate(n, (_) => r.nextInt(6));
    eq(nextGreaterValues(a), List.generate(n, (i) { for (var j = i + 1; j < n; j++) { if (a[j] > a[i]) return a[j]; } return -1; }), 'ng');
    eq(nextGreaterCircular(a), List.generate(n, (i) { for (var d = 1; d < n; d++) { if (a[(i + d) % n] > a[i]) return a[(i + d) % n]; } return -1; }), 'ngc');
    final ps = PriceSpan(); for (var i = 0; i < n; i++) { var s = 0; for (var j = i; j >= 0 && a[j] <= a[i]; j--) s++; eq(ps.next(a[i]), s, 'span'); }
    var tot = 0; for (var i = 0; i < n; i++) for (var j = i; j < n; j++) tot += a.sublist(i, j + 1).reduce(min); eq(sumSubarrayMins(a), tot, 'ssm');
    final num = a.join(); final k = r.nextInt(n + 1); String? best;
    void rec(int i, String cur) { if (cur.length == n - k) { var v = cur.replaceFirst(RegExp(r'^0+'), ''); if (v.isEmpty) v = '0'; if (best == null || v.length < best!.length || (v.length == best!.length && v.compareTo(best!) < 0)) best = v; return; } if (i == n) return; rec(i + 1, cur + num[i]); rec(i + 1, cur); }
    rec(0, ''); eq(removeKdigits(num, k), best, 'rk');
  }
  print('dart ok');
}
