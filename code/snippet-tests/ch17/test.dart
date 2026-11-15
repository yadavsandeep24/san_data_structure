
import 'dart:math';
void eq(Object? a, Object? b, String m) { if (a.toString() != b.toString()) throw Exception('$m got $a want $b'); }
void main() {
  final r = Random(13);
  List<List<int>> gen() => List.generate(r.nextInt(7), (_) { final s = r.nextInt(15); return [s, s + 1 + r.nextInt(5)]; });
  for (var t = 0; t < 500; t++) {
    final iv = gen();
    var pk = 0; for (var x = 0; x < 25; x++) pk = max(pk, iv.where((v) => v[0] <= x && x < v[1]).length);
    eq(peakConcurrent(iv), pk, 'peak'); eq(canAttendAll(iv), pk <= 1, 'attend');
    final m = mergeBusy(iv);
    for (var x = 0; x < 25; x++) { eq(m.any((v) => v[0] <= x && x < v[1]), iv.any((v) => v[0] <= x && x < v[1]), 'mergecov'); }
    for (var i = 1; i < m.length; i++) { if (m[i][0] <= m[i - 1][1]) throw Exception('not merged'); }
    var kept = 0; for (var i = 0; i < iv.length; i++) { var cov = false; for (var j = 0; j < iv.length; j++) { if (j != i && iv[j][0] <= iv[i][0] && iv[i][1] <= iv[j][1] && (iv[j][0] != iv[i][0] || iv[j][1] != iv[i][1] || j < i)) cov = true; } if (!cov) kept++; }
    eq(removeCoveredIntervals(iv), kept, 'cov');
    final A = mergeBusy(gen()), B = mergeBusy(gen()); final d = 1 + r.nextInt(4); List<int>? ans;
    bool ok(List<List<int>> L, int st) => L.any((v) => v[0] <= st && st + d <= v[1]);
    for (var st = 0; st < 30 && ans == null; st++) { if (ok(A, st) && ok(B, st)) ans = [st, st + d]; }
    eq(meetingScheduler(A, B, d), ans, 'sched');
  }
  print('dart ok');
}
