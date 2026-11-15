
import 'dart:math';
void main() { final r = Random(3);
  for (var t = 0; t < 300; t++) { final f = List.generate(1 + r.nextInt(8), (_) => 1 + r.nextInt(9)); final d = 1 + r.nextInt(f.length);
    var q = f.reduce(max); int need(int Q) { var u = 0, c = 1; for (final x in f) { if (u + x > Q) { c++; u = 0; } u += x; } return c; }
    while (need(q) > d) q++; if (minDailyQuota(f, d) != q) throw Exception('q'); }
  print('dart ok'); }
